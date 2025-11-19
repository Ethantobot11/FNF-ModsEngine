package objects;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

class LoadingScreen extends FlxGroup
{
    public var bg:FlxSprite;
    public var dots:Array<FlxSprite> = [];
    public var alphaTarget:Float = 0;
    public var rotationSpeed:Float = 80;
    public var radius:Float = 60;
    public static var loading:Bool = false;
    public static var instance:LoadingScreen;

    public function new()
    {
        super();

        instance = this;
        loading = true;

        // Background overlay
        bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        bg.alpha = 0.6;
        add(bg);

        // Create circle dots
        for (i in 0...4)
        {
            var dot = new FlxSprite().makeGraphic(10, 10, FlxColor.WHITE);
            dot.updateHitbox();
            add(dot);
            dots.push(dot);
        }

        // Fade in
        alpha = 0;
        alphaTarget = 1;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // Fade effect
        alpha = lerp(alpha, alphaTarget, elapsed * 6);

        if (alpha == 0) return; // prevent drawing when invisible

        var angleStep = 360 / dots.length;
        var centerX = FlxG.width / 2;
        var centerY = FlxG.height / 2;

        for (i in 0...dots.length)
        {
            var dot = dots[i];
            var angle = (FlxG.game.ticks * 0.2 + angleStep * i) % 360;

            dot.x = centerX + Math.cos(angle * (Math.PI / 180)) * radius;
            dot.y = centerY + Math.sin(angle * (Math.PI / 180)) * radius;
        }
    }

    public static function toggle(show:Bool)
    {
        if (instance == null) return;

        loading = show;
        instance.alphaTarget = show ? 1 : 0;

        if (!show)
        {
            FlxTween.tween(instance, {alpha: 0}, 0.5, {
                onComplete: _ -> {
                    instance.kill();
                }
            });
        }
    }
}
