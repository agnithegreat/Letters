/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.display.Sprite;
import flash.events.Event;

public class SelectLetterScreen extends Sprite {

    public function SelectLetterScreen() {
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    private function handleAddedToStage(e: Event):void {
        stage.addEventListener(Event.RESIZE, handleResize);
        handleResize(null);

        removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
    }

    private function handleRemovedFromStage(e: Event):void {
        stage.removeEventListener(Event.RESIZE, handleResize);

        removeEventListener(Event.REMOVED_FROM_STAGE, handleRemovedFromStage);
        addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
    }

    public function init(letters: Array):void {

        var l: int = letters.length;
        for (var i: int = 0; i < l; i++) {
            var data: Object = letters[i];
            var letter: LetterView = new LetterView(data);
            addChild(letter);
            letter.x = (i%2 - 0.5) * letter.width * 1.1;
            letter.y = (int(i/2) - int(l/2)/2) * letter.height;
        }
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
}
}
