/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.display.SimpleButton;

import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class GameScreen extends GameScreenMC {

    public static const BACK: String = "back_GameScreen";

    private var _container: Sprite;

    private var _backBtn: SimpleButton;

    private var _softCount: int;
    private var _strongCount: int;

    private var _softHitRect: Rectangle;
    private var _strongHitRect: Rectangle;

    public function GameScreen() {
        _backBtn = back_btn;
        _backBtn.addEventListener(MouseEvent.CLICK, handleBackClick);

        _container = new Sprite();
        addChild(_container);

        _softHitRect = boys.soft.getBounds(this);
        _strongHitRect = boys.strong.getBounds(this);
    }

    public function init(imagesData: Array, imagesDict: Dictionary):void {
        stage.addEventListener(Event.RESIZE, handleResize);
        handleResize(null);

        var l: int = imagesData.length;
        for (var i: int = 0; i < l; i++) {
            var data: Object = imagesData[i];
            var image: ImageView = new ImageView(data, imagesDict[data.name]);
            image.addEventListener(ImageView.CHECK, handleCheck);
            _container.addChild(image);
        }

        _softCount = 0;
        _strongCount = 0;
    }

    private function handleCheck(e: Event):void {
        var image: ImageView = e.currentTarget as ImageView;
        if (_softHitRect.containsPoint(image.current)) {
            if (image.data.value == "soft") {
                image.accept(_softHitRect.x + _softHitRect.width/2, 300 + 120 * (++_softCount));
            } else {
                image.decline();
            }
        } else if (_strongHitRect.containsPoint(image.current)) {
            if (image.data.value == "strong") {
                image.accept(_strongHitRect.x + _strongHitRect.width/2, 300 + 120 * (++_strongCount));
            } else {
                image.decline();
            }
        } else {
            image.cancel();
        }
    }

    private function handleResize(e: Event):void {
        var xScale: Number = stage.stageWidth / 1920;
        var yScale: Number = stage.stageHeight / 1200;
        var minScale: Number = Math.min(xScale, yScale);
        scaleX = minScale;
        scaleY = minScale;

        if (xScale > minScale) {
            x = 960 * (xScale - minScale);
        }
    }

    private function handleBackClick(e: MouseEvent):void {
        dispatchEvent(new Event(BACK));
    }

    public function destroy():void {
        if (stage) {
            stage.removeEventListener(Event.RESIZE, handleResize);
        }

        while (_container.numChildren > 0) {
            var imageView: ImageView = _container.getChildAt(0) as ImageView;
            imageView.removeEventListener(ImageView.CHECK, handleCheck);
            imageView.destroy();
            _container.removeChild(imageView);
        }
        removeChild(_container);
        _container = null;

        _backBtn.removeEventListener(MouseEvent.CLICK, handleBackClick);
        removeChild(_backBtn);
        _backBtn = null;

        _softHitRect = null;
        _strongHitRect = null;
    }
}
}
