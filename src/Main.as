/**
 * Created by kirillvirich on 18.03.15.
 */
package {

[SWF (frameRate=60, width=1920, height=1200)]
public class Main extends MainBase {

    private var _app: App;

    public function Main() {
        super();
    }

    override protected function initialize():void {
        super.initialize();

        var minScale: Number = Math.min(stage.stageWidth / 1920, stage.stageHeight / 1200);
        scaleX = minScale;
        scaleY = minScale;

        _app = new App();
        addChild(_app);
    }
}
}
