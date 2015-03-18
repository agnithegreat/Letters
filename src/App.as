/**
 * Created by kirillvirich on 18.03.15.
 */
package {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Dictionary;

import view.GameScreen;
import view.LetterView;
import view.MainMenu;

public class App extends Sprite {

    private var _config: Object;

    private var _lettersArray: Array;

    private var _lettersDict: Dictionary;
    private var _imagesDict: Dictionary;

    private var _queue: Array;

    private var _configLoader: URLLoader;
    private var _imageLoader: Loader;

    private var _main: MainMenu;
    private var _game: GameScreen;

    public function App() {
        _configLoader = new URLLoader();
        _configLoader.addEventListener(Event.COMPLETE, handleConfigLoaded);
        _configLoader.load(new URLRequest("config.json"));
    }

    private function handleConfigLoaded(e: Event):void {
        _configLoader.removeEventListener(Event.COMPLETE, handleConfigLoaded);
        _config = JSON.parse(_configLoader.data);

        _lettersArray = [];
        _lettersDict = new Dictionary();
        _imagesDict = new Dictionary();
        _queue = [];

        for (var letter: String in _config.letters) {
            _lettersArray.push(_config.letters[letter]);
            _lettersDict[letter] = [];
            var ok: Boolean = true;
            var i: int = 1;
            while (ok) {
                var id: String = letter+"."+i;
                if (_config.words.hasOwnProperty(id)) {
                    var data: Object = _config.words[id];
                    _lettersDict[letter].push(data);
                    _queue.push(data);
                } else {
                    ok = false;
                }
                i++;
            }
        }

        _imageLoader = new Loader();
        _imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoaded);
        loadNext();
    }

    private function loadNext():void {
        if (_queue.length > 0) {
            var path: String = "images/" + _queue[0].folder + "/" + _queue[0].filename;

            _imageLoader.load(new URLRequest(path));
        } else {
            _main = new MainMenu();
            addChild(_main);
            _main.addEventListener(LetterView.CLICK, handleClick);
            _main.init(_lettersArray);
        }
    }

    private function handleClick(e: Event):void {
        var target: LetterView = e.target as LetterView;
        initGame(target.data.name);
    }

    private function handleImageLoaded(e: Event):void {
        _imagesDict[_queue[0].name] = Bitmap(_imageLoader.content).bitmapData;
        _queue.shift();
        loadNext();
    }

    private function initGame(letter: String):void {
        removeChild(_main);

        _game = new GameScreen();
        addChild(_game);
        _game.init(_lettersDict[letter], _imagesDict);
    }
}
}
