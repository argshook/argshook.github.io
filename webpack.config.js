const path = require('path');
const webpack = require('webpack');
const deepAssign = require('deep-assign');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const HtmlWebpackInlineSourcePlugin = require('html-webpack-inline-source-plugin');

const excludes = ['/node_modules/', '/elm-stuff/'];

const config = {
  entry: {
    bundle: path.resolve(__dirname, 'src', 'index.js')
  },

  output: {
    path: path.resolve(__dirname),
    filename: '[name].min.js',
    publicPath: '/'
  },

  resolve: {
    alias: {
      hljs: path.resolve(__dirname, 'node_modules/highlight.js')
    }
  },

  module: {
    rules: [
      {
        test: /\.json/,
        exclude: excludes,
        use: 'json-loader'
      },
      {
        test: /\.html$/,
        exclude: excludes,
        use: 'html-loader'
      },
      {
        test: /\.elm$/,
        exclude: excludes,
        use: [
          { loader: 'elm-hot-loader' },
          {
            loader: 'elm-webpack-loader',
            options: {
              verbose: true,
              warn: true
            }
          }
        ]
      },
      {
        test: /\.js/,
        exclude: excludes,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['es2015']
          }
        }
      },
      {
        test: /\.css$/,
        exclude: excludes,
        use: [
          'style-loader',
          'css-loader',
          {
            loader: 'postcss-loader',
            options: {
              plugins: () => [ require('autoprefixer'), require('precss') ]
            }
          }
        ]
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: 'url-loader?limit=10000&mimetype=application/font-woff'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        use: 'file-loader'
      }
    ]
  },

  plugins: [
    new HtmlWebpackPlugin({
      template: 'src/index.ejs',
      inlineSource: '.(js|css)$',
      minify: {
        removeComments: true,

      }
    }),
    new HtmlWebpackInlineSourcePlugin()
  ]
};

const devConfig = {
  plugins: (config.plugins || [])
    .concat([new webpack.HotModuleReplacementPlugin()]),

  devServer: {
    inline: true,
    hot: true,
    noInfo: true,
    stats: {
      colors: true
    }
  }
};

const prodConfig = {
  plugins: (config.plugins || []).concat([
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
        screw_ie8: true,
        conditionals: true,
        unused: true,
        comparisons: true,
        sequences: true,
        dead_code: true,
        evaluate: true,
        if_return: true,
        join_vars: true
      }
    }),
    new webpack.DefinePlugin({
      'process.env': {
        NODE_ENV: '"production"'
      }
    })
  ])
};

function makeConfig(config) {
  switch (process.env.NODE_ENV) {
    case 'dev':
    default:
      return deepAssign({}, config, devConfig);

    case 'prod':
      return deepAssign({}, config, prodConfig);
  }
}

module.exports = makeConfig(config);
