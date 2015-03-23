/**
 * Created by desktop on 19.03.2015.
 */
package view {
import caurina.transitions.Equations;
import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ImageView extends Sprite {

    public static const CHECK: String = "check_ImageView";

    private var _data: Object;
    public function get data():Object {
        return _data;
    }

    private var _bitmap: Bitmap;

    private var _position: Point;
    private var _moveStart: Point;
    private var _moveCurrent: Point;
    public function get current():Point {
        return _moveCurrent;
    }

    public function ImageView(data: Object, image: BitmapData) {
        _data = data;

        var pos: Array = _data.position.split(",");
        _position = new Point(pos[0], pos[1]);
        _position.x += image.width/2;
        _position.y += image.height/2;

        _bitmap = new Bitmap(image);
        _bitmap.x = -image.width * 0.4;
        _bitmap.y = -image.height * 0.4;
        _bitmap.scaleX = 0.8;
        _bitmap.scaleY = 0.8;
        addChild(_bitmap);

        _moveStart = new Point();
        _moveCurrent = new Point();
        updatePosition(false);

        addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
    }

    public function accept(posX: int, posY: int):void {
        Tweener.addTween(this, {x: posX, y: posY, scaleX: 0.5, scaleY: 0.5, time: 0.3});

        removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
        mouseEnabled = false;
        mouseChildren = false;
    }

    public function decline():void {
        Tweener.addTween(this, {scaleX: -1, time: 0.3});
        Tweener.addTween(this, {scaleX: 1, time: 0.3, delay: 0.3});
        Tweener.addTween(this, {scaleX: -1, time: 0.3, delay: 0.6});
        Tweener.addTween(this, {scaleX: 1, time: 0.3, delay: 0.9});
        updatePosition(true, 1.2);
    }

    public function cancel():void {
        updatePosition(true);
    }

    private function updatePosition(animate: Boolean, animateDelay: Number = 0):void {
        if (animate) {
            Tweener.addTween(this, {x: _position.x, y: _position.y, time: 0.3, delay: animateDelay, transition: Equations.easeInOutQuad});
        } else {
            x = _position.x;
            y = _position.y;
        }
    }

    private function handleMouseDown(e: MouseEvent):void {
        parent.addChild(this);

        _moveStart.x = parent.mouseX;
        _moveStart.y = parent.mouseY;

        stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
    }

    private function handleMouseMove(e: MouseEvent):void {
        if (stage) {
            _moveCurrent.x = parent.mouseX;
            _moveCurrent.y = parent.mouseY;

            Tweener.removeTweens(this);
            Tweener.addTween(this, {x: _position.x + _moveCurrent.x-_moveStart.x, y: _position.y + _moveCurrent.y-_moveStart.y, time: 0.1});
        }
    }

    private function handleMouseUp(e: MouseEvent):void {
        if (stage) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);

            dispatchEvent(new Event(CHECK));
        }
    }

    public function destroy():void {
        if (stage) {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
        }

        _data = null;

        removeChild(_bitmap);
        _bitmap.bitmapData = null;
        _bitmap = null;

        _position = null;
        _moveStart = null;
        _moveCurrent = null;

        removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
    }
}
}
