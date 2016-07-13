import './styles/main.scss';
import '../node_modules/basscss/css/basscss.css';
import '../node_modules/basscss-forms/index.css';

const Elm = require('./Main.elm');

Elm.Main.embed(document.getElementById('app'));

