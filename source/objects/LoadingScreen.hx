package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;

class LoadingScreen extends FlxGroup
{
    public var bg:FlxSprite;
    public var dots:Array<FlxSprite> = [];
    public var currentAlpha:Float = 0;
    public var targetAlpha:Float = 1;
    public static var instance:LoadingScreen;

    public function new()
    {
        super();

        instance = this;

        // Background overlay
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        add(bg);

        // Create spinning dots
        for (i in 0...4)
        {
            var dot = new FlxSprite().makeGraphic(10, 10, FlxColor.WHITE);
            dots.push(dot);
            add(dot);
        }

        // Start invisible
        currentAlpha = 0;
        setAlpha(0);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        // Smooth fade
        currentAlpha += (targetAlpha - currentAlpha) * 6 * elapsed;
        setAlpha(currentAlpha);

        // Don't update circle if invisible
        if (currentAlpha <= 0.01) return;

        var centerX = FlxG.width / 2;
        var centerY = FlxG.height / 2;
        var angleStep = 360 / dots.length;

        for (i in 0...dots.length)
        {
            var angle = (FlxG.game.ticks * 0.2 + angleStep * i);
            dots[i].x = centerX + Math.cos(angle * Math.PI / 180) * 60;
            dots[i].y = centerY + Math.sin(angle * Math.PI / 180) * 60;
        }
    }

    /** Applies alpha to all elements */
    public function setAlpha(val:Float)
    {
        bg.alpha = 0.6 * val;

        for (dot in dots)
            dot.alpha = val;
    }

    public static function toggle(show:Bool)
    {
        if (instance == null) return;

        instance.targetAlpha = show ? 1 : 0;

        // Fade out fully then remove
        if (!show)
        {
            FlxTween.tween(instance, {currentAlpha:0}, 0.5, {
                onComplete: _ -> instance.kill()
            });
        }
    }
}
