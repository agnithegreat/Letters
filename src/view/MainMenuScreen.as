/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;

public class MainMenuScreen extends MainMenuScreenMC {

    public static const INFO: String = "info_MainMenuScreen";
    public static const SELECT: String = "select_MainMenuScreen";

    private var _info: TextField;
    private var _select: TextField;

    public function MainMenuScreen() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(e: Event):void {
        stage.addEventListener(Event.RESIZE, handleResize);
        handleResize(null);

        _info = btn_rules;
        _info.addEventListener(MouseEvent.CLICK, handleClick);

        _select = btn_select;
        _select.addEventListener(MouseEvent.CLICK, handleClick);

        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
    }

    private function handleRemovedFromStage(e: Event):void {
        stage.removeEventListener(Event.RESIZE, handleResize);

        removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleResize(e: Event):void {
        var xScale: Number = stage.stageWidth / 1920;
        var yScale: Number = stage.stageHeight / 1200;
        var minScale: Number = Math.min(xScale, yScale);
        scaleX = minScale;
        scaleY = minScale;

        x = stage.stageWidth/2;
        y = stage.stageHeight/2;
    }

    private function handleClick(e: MouseEvent):void {
        switch (e.currentTarget) {
            case _info:
                dispatchEvent(new Event(INFO));
                break;
            case _select:
                dispatchEvent(new Event(SELECT));
                break;
        }
    }
}
}
