/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.events.Event;
import flash.events.MouseEvent;

public class LetterView extends LetterMC {

    public static const CLICK: String = "click_LetterView";

    private var _data: Object;
    public function get data():Object {
        return _data;
    }

    public function LetterView(data: Object) {
        _data = data;

        letter.text = _data.letter;
        letter.textColor = _data.color.replace("#", "0x");

        addEventListener(MouseEvent.CLICK, handleClick);
    }

    private function handleClick(e: MouseEvent):void {
        dispatchEvent(new Event(CLICK, true));
    }
}
}
