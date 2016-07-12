const path = require('path');
const webpack = require('webpack');

const excludes = ['/node_modules/', '/elm-stuff/'];


module.exports = {
  entry: {
    bundle: path.resolve(__dirname, 'src', 'index.js')
  },

  output: {
    path: path.resolve(__dirname),
    filename: '[name].min.js',
    publicPath: '/'
  },

  module: {
    loaders: [
      {
        test: /\.html$/,
        exclude: excludes,
        loader: 'html'
      },
      {
        test: /\.elm$/,
        exclude: excludes,
        loader: 'elm-webpack'
      },
      {
        test: /\.js/,
        exclude: excludes,
        loader: 'babel-loader',
        query: {
          presets: ['es2015']
        }
      },
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'url?limit=10000&mimetype=application/font-woff'
      },
      {
        test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
        loader: 'file'
      }
    ],
  },

  plugins: [
    new webpack.optimize.DedupePlugin(),
    //new webpack.optimize.UglifyJsPlugin()
  ],

  devServer: {
    inline: true,
    stats: {
      colors: true
    }
  }
};

