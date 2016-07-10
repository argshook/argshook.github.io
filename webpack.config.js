const path = require('path');

const excludes = ['/node_modules/', '/elm-stuff/'];


module.exports = {
  entry: {
    app: path.resolve(__dirname, 'app.js')
  },

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: '[name].js'
  },

  module: {
    loaders: [
      {
        test: /\.html$/,
        exclude: excludes,
        loader: 'file?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: excludes,
        loader: 'elm-webpack'
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

  devServer: {
    inline: true,
    stats: {
      colors: true
    }
  }
};

