/**
 * Created by desktop on 19.03.2015.
 */
package view {
import flash.display.Sprite;
import flash.utils.Dictionary;

public class GameScreen extends GameScreenMC {

    private var _container: Sprite;

    public function GameScreen() {
        _container = new Sprite();
        addChild(_container);
    }

    public function init(imagesData: Array, imagesDict: Dictionary):void {
        var l: int = imagesData.length;
        for (var i: int = 0; i < l; i++) {
            var data: Object = imagesData[i];
            var image: ImageView = new ImageView(data, imagesDict[data.name]);
            _container.addChild(image);
        }
    }
}
}
