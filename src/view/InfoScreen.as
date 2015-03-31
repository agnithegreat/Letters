/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

public class InfoScreen extends InfoScreenMC {

    public static const BACK: String = "back_InfoScreen";

    private var _backBtn: SimpleButton;

    public function InfoScreen() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(e: Event):void {
        stage.addEventListener(Event.RESIZE, handleResize);
        handleResize(null);

        _backBtn = back_btn;
        _backBtn.addEventListener(MouseEvent.CLICK, handleBackClick);

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

    private function handleBackClick(e: MouseEvent):void {
        dispatchEvent(new Event(BACK));
    }
}
}
