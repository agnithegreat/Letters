/**
 * Created by kirillvirich on 18.03.15.
 */
package {
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.utils.setTimeout;

import view.GameScreen;
import view.InfoScreen;
import view.LetterView;
import view.MainMenuScreen;
import view.MainScreen;
import view.SelectLetterScreen;

public class App extends Sprite {

    private var _config: Object;

    private var _lettersArray: Array;

    private var _lettersDict: Dictionary;
    private var _imagesDict: Dictionary;

    private var _queue: Array;

    private var _configLoader: URLLoader;
    private var _imageLoader: Loader;

    private var _main: MainScreen;
    private var _menu: MainMenuScreen
    private var _info: InfoScreen;
    private var _select: SelectLetterScreen;
    private var _game: GameScreen;

    private var _readyToStart: Boolean;

    public function App() {
        _main = new MainScreen();
        addChild(_main);

        setTimeout(start, 3000);

        _configLoader = new URLLoader();
        _configLoader.addEventListener(Event.COMPLETE, handleConfigLoaded);
        _configLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
        _configLoader.load(new URLRequest(encodeURI("config.json")));
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
        _imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);
        _imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleImageLoaded);
        loadNext();
    }

    private function handleIOError(e: IOErrorEvent):void {
        trace(e.currentTarget, e);
    }

    private function loadNext():void {
        if (_queue.length > 0) {
            var path: String = encodeURI("images/" + _queue[0].folder + "/" + _queue[0].filename);

            _imageLoader.load(new URLRequest(path));
        } else {
            start();
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

    private function start():void {
        if (_readyToStart) {
            removeChild(_main);

            if (!_menu) {
                _menu = new MainMenuScreen();
                _menu.addEventListener(MainMenuScreen.INFO, showInfo);
                _menu.addEventListener(MainMenuScreen.SELECT, showLetters);
            }
            addChild(_menu);
        } else {
            _readyToStart = true;
        }
    }

    private function showInfo(e: Event):void {
        removeChild(_menu);

        if (!_info) {
            _info = new InfoScreen();
            _info.addEventListener(InfoScreen.BACK, handleBackToMainMenu);
        }
        addChild(_info);
    }

    private function handleBackToMainMenu(e: Event):void {
        removeChild(_info);
        addChild(_menu);
    }

    private function showLetters(e: Event):void {
        removeChild(_menu);

        _select = new SelectLetterScreen();
        addChild(_select);
        _select.addEventListener(LetterView.CLICK, handleClick);
        _select.addEventListener(SelectLetterScreen.BACK, handleBackToMenu);
        _select.init(_lettersArray);
    }

    private function handleBackToMenu(e: Event):void {
        removeChild(_select);
        addChild(_menu);
    }

    private function initGame(letter: String):void {
        removeChild(_select);

        _game = new GameScreen();
        _game.addEventListener(GameScreen.BACK, handleBack);
        addChild(_game);
        _game.init(_lettersDict[letter], _imagesDict);
    }

    private function handleBack(e: Event):void {
        _game.removeEventListener(GameScreen.BACK, handleBack);
        _game.destroy();
        removeChild(_game);
        _game = null;

        addChild(_select);
    }
}
}
