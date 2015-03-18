/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.display.Sprite;
import flash.utils.Dictionary;

public class MainMenu extends Sprite {

    public function MainMenu() {
    }

    public function init(letters: Array):void {
        var l: int = letters.length;
        for (var i: int = 0; i < l; i++) {
            var data: Object = letters[i];
            var letter: LetterView = new LetterView(data);
            addChild(letter);
            letter.x = (i%3-1.5) * letter.width * 0.9;
            letter.y = (int(i/3)-1) * letter.height * 0.8;
        }

        x = 960;
        y = 600;
    }
}
}
