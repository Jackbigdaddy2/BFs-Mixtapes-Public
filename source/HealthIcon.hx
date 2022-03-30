package;

import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;

	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(?char:String = "bf", ?isPlayer:Bool = false)
	{
		super();

		// if(FlxG.save.data.antialiasing)
		// 	{
		// 		antialiasing = true;
		// 	}
		// if (char == 'sm')
		// {
		// 	loadGraphic(Paths.image("stepmania-icon"));
		// 	return;
		// }
		// loadGraphic(Paths.image('iconGrid'), true, 150, 150);
		// animation.add('bf', [0, 1], 0, false, isPlayer);
		// animation.add('bf-car', [0, 1], 0, false, isPlayer);
		// animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
		// animation.add('bf-pixel', [21], 0, false, isPlayer);
		// animation.add('bf-holding-gf', [0, 1], 0, false, isPlayer);
		// animation.add('spooky', [2, 3], 0, false, isPlayer);
		// animation.add('pico', [4, 5], 0, false, isPlayer);
		// animation.add('mom', [6, 7], 0, false, isPlayer);
		// animation.add('mom-car', [6, 7], 0, false, isPlayer);
		// animation.add('tankman', [8, 9], 0, false, isPlayer);
		// animation.add('face', [10, 11], 0, false, isPlayer);
		// animation.add('dad', [12, 13], 0, false, isPlayer);
		// animation.add('senpai', [22], 0, false, isPlayer);
		// animation.add('senpai-angry', [22], 0, false, isPlayer);
		// animation.add('spirit', [23], 0, false, isPlayer);
		// animation.add('bf-old', [14, 15], 0, false, isPlayer);
		// animation.add('gf', [16], 0, false, isPlayer);
		// animation.add('gf-car', [16], 0, false, isPlayer);
		// animation.add('gf-christmas', [16], 0, false, isPlayer);
		// animation.add('gf-pixel', [16], 0, false, isPlayer);
		// animation.add('gf-tankmen', [16], 0, false, isPlayer);
		// animation.add('pico-speaker', [4, 5], 0, false, isPlayer);
		// animation.add('parents-christmas', [17, 18], 0, false, isPlayer);
		// animation.add('monster', [19, 20], 0, false, isPlayer);
		// animation.add('monsterclassic', [19, 20], 0, false, isPlayer);
		// animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
		// animation.add('griff', [24, 25], 0, false, isPlayer);
		// animation.play(char);
		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;

		changeIcon(char);
		scrollFactor.set();
	}

	public function swapOldIcon()
	{
		if (char == 'djprince')
			(isOldIcon = !isOldIcon)
		?changeIcon("steve")
		:changeIcon(char);
	else
		(isOldIcon = !isOldIcon) ? changeIcon("bf-old") : changeIcon(char);
	}

	public function changeIcon(char:String)
	{
		if (char != 'bf-pixel' && char != 'bf-old')
			char = char.split("-")[0];

		if (!OpenFlAssets.exists(Paths.image('icons/icon-' + char)))
			char = 'face';

		loadGraphic(Paths.loadImage('icons/icon-' + char), true, 150, 150);

		if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit') || char.endsWith('pixelenemy') || char.startsWith('djprince')
			|| char.startsWith('villager') || char.startsWith('steve') || char.startsWith('abf') || char.startsWith('bubbo') || char.startsWith('oddub')
			|| char.startsWith('funny') || char.startsWith('professor-eevee'))
			antialiasing = false
		else
			antialiasing = FlxG.save.data.antialiasing;

		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
