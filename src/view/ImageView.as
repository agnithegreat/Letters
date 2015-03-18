/**
 * Created by desktop on 19.03.2015.
 */
package view {
import caurina.transitions.Equations;
import caurina.transitions.Tweener;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

public class ImageView extends Sprite {

    private var _data: Object;

    private var _bitmap: Bitmap;

    private var _position: Point;
    private var _moveStart: Point;
    private var _moveCurrent: Point;

    public function ImageView(data: Object, image: BitmapData) {
        _data = data;

        _bitmap = new Bitmap(image);
        _bitmap.x = image.width * 0.1;
        _bitmap.y = image.height * 0.1;
        _bitmap.scaleX = 0.8;
        _bitmap.scaleY = 0.8;
        addChild(_bitmap);

        _moveStart = new Point();
        _moveCurrent = new Point();

        var pos: Array = _data.position.split(",");
        _position = new Point(pos[0], pos[1]);
        updatePosition(false);

        addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
    }

    private function updatePosition(animate: Boolean):void {
        if (animate) {
            Tweener.removeTweens(this);
            Tweener.addTween(this, {x: _position.x, y: _position.y, time: 0.3, transition: Equations.easeInOutQuad});
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
        _moveCurrent.x = parent.mouseX;
        _moveCurrent.y = parent.mouseY;

        Tweener.removeTweens(this);
        Tweener.addTween(this, {x: _position.x + _moveCurrent.x-_moveStart.x, y: _position.y + _moveCurrent.y-_moveStart.y, time: 0.1});
    }

    private function handleMouseUp(e: MouseEvent):void {
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
        stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);

        updatePosition(true);
    }
}
}
