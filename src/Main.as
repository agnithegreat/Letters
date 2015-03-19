/**
 * Created by kirillvirich on 18.03.15.
 */
package {

[SWF (frameRate=60)]
public class Main extends MainBase {

    private var _app: App;

    public function Main() {
        super();
    }

    override protected function initialize():void {
        super.initialize();

        _app = new App();
        addChild(_app);
    }
}
}
