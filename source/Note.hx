package;

import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
#if polymod
import polymod.format.ParseRules.TargetSignatureElement;
#end
import PlayState;

using StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;
	public var baseStrum:Float = 0;

	public var charterSelected:Bool = false;

	public var rStrumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var rawNoteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	public var modifiedByLua:Bool = false;
	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;
	public var originColor:Int = 0; // The sustain note's original note's color
	public var noteSection:Int = 0;

	public var luaID:Int = 0;

	public var isAlt:Bool = false;

	public var noteCharterObject:FlxSprite;

	public var noteScore:Float = 1;

	public var noteYOff:Int = 0;

	public var beat:Float = 0;

	public static var mania:Int = 0; // 9 key
	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;
	public static var noteScale = 0.7; // 9 key

	public static var noteScales:Array<Float> = [0.7, 0.5]; // 9 key
	public static var noteWidths:Array<Float> = [112, 66.5];
	public static var frameN:Array<Dynamic> = [
		['purple', 'blue', 'green', 'red'],
		['purple', 'blue', 'green', 'red', 'white', 'yellow', 'violet', 'darkred', 'dark'],
	]; // end of 9 key

	public var rating:String = "shit";

	public var modAngle:Float = 0; // The angle set by modcharts
	public var localAngle:Float = 0; // The angle to be edited inside Note.hx
	public var originAngle:Float = 0; // The angle the OG note of the sus note had (?)

	public var dataColor:Array<String> = ['purple', 'blue', 'green', 'red'];
	public var quantityColor:Array<Int> = [RED_NOTE, 2, BLUE_NOTE, 2, PURP_NOTE, 2, GREEN_NOTE, 2];
	public var arrowAngles:Array<Int> = [180, 90, 270, 0];

	public var isParent:Bool = false;
	public var parent:Note = null;
	public var spotInLine:Int = 0;
	public var sustainActive:Bool = true;

	public var children:Array<Note> = [];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?inCharter:Bool = false, ?isAlt:Bool = false, ?bet:Float = 0)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		mania = 0; // 9 key
		if (PlayState.SONG.mania != 0)
		{
			mania = PlayState.SONG.mania;
			swagWidth = noteWidths[mania];
			noteScale = noteScales[mania];
		} // end of 9 key

		beat = bet;

		this.isAlt = isAlt;

		this.prevNote = prevNote;
		isSustainNote = sustainNote;

		x += 50;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		if (inCharter)
		{
			this.strumTime = strumTime;
			rStrumTime = strumTime;
		}
		else
		{
			this.strumTime = strumTime;
			#if FEATURE_STEPMANIA
			if (PlayState.isSM)
			{
				rStrumTime = strumTime;
			}
			else
				rStrumTime = strumTime;
			#else
			rStrumTime = strumTime;
			#end
		}

		if (this.strumTime < 0)
			this.strumTime = 0;

		this.noteData = noteData;

		var daStage:String = ((PlayState.instance != null && !PlayStateChangeables.Optimize) ? PlayState.Stage.curStage : 'stage');

		// defaults if no noteStyle was found in chart
		var noteTypeCheck:String = 'normal';

		if (inCharter)
		{
			frames = PlayState.noteskinSprite;

			for (i in 0...9) // (i in 0...4) // 9 key
			{
				animation.addByPrefix(frameN[1][i] + 'Scroll', frameN[1][i] + '0'); // Normal notes
				animation.addByPrefix(frameN[1][i] + 'hold', frameN[1][i] + ' hold piece'); // Hold
				animation.addByPrefix(frameN[1][i] + 'holdend', frameN[1][i] + ' hold end'); // Tails
			} // dataColor > frameN[1] for 9 key

			setGraphicSize(Std.int(width * 0.7));
			updateHitbox();
			antialiasing = FlxG.save.data.antialiasing;
		}
		else
		{
			if (PlayState.SONG.noteStyle == null)
			{
				switch (PlayState.storyWeek)
				{
					case 6:
						noteTypeCheck = 'pixel';
				}
			}
			else
			{
				noteTypeCheck = PlayState.SONG.noteStyle;
			}

			switch (noteTypeCheck)
			{
				case 'pixel':
					loadGraphic(PlayState.noteskinPixelSprite, true, 17, 17);
					if (isSustainNote)
						loadGraphic(PlayState.noteskinPixelSpriteEnds, true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}

					setGraphicSize(Std.int(width * CoolUtil.daPixelZoom));
					updateHitbox();
				case 'minecraftui':
					loadGraphic(Paths.image('Minecraft_Button_Notes'), true, 17, 17);
					if (isSustainNote)
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}

					setGraphicSize(Std.int(width * CoolUtil.daPixelZoom));
					updateHitbox();
				case 'minecraftuithick':
					loadGraphic(Paths.image('Minecraft_Button_Notes_Thick'), true, 17, 17);
					if (isSustainNote)
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}

					setGraphicSize(Std.int(width * CoolUtil.daPixelZoom));
					updateHitbox();

				case 'mondaynightmania':
					loadGraphic(Paths.image('Minecraft_Notes'), true, 102, 102);
					if (isSustainNote)
						loadGraphic(Paths.image('weeb/pixelUI/arrowEnds'), true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}
				// case 'minecraft':
				// 	frames = Paths.getSparrowAtlas('Minecraft_Notes');

				// 	for (i in 0...4)
				// 	{
				// 		animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
				// 		animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
				// 		animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
				// 	}

				// 	setGraphicSize(Std.int(width * 0.7));
				// 	updateHitbox();

				// 	if(FlxG.save.data.antialiasing)
				// 		{
				// 			antialiasing = true;
				// 		}
				case 'jforce':
					frames = Paths.getSparrowAtlas('noteskins/JForce', 'shared');

					for (i in 0...4)
					{
						animation.addByPrefix(dataColor[i] + 'Scroll', dataColor[i] + ' alone'); // Normal notes
						animation.addByPrefix(dataColor[i] + 'hold', dataColor[i] + ' hold'); // Hold
						animation.addByPrefix(dataColor[i] + 'holdend', dataColor[i] + ' tail'); // Tails
					}

					setGraphicSize(Std.int(width * 0.7));
					updateHitbox();

					antialiasing = FlxG.save.data.antialiasing;
				case 'xg':
					loadGraphic(Paths.image('noteskins/XG', 'shared'), true, 17, 17);
					if (isSustainNote)
						loadGraphic(Paths.image('noteskins/XG-ends', 'shared'), true, 7, 6);

					for (i in 0...4)
					{
						animation.add(dataColor[i] + 'Scroll', [i + 4]); // Normal notes
						animation.add(dataColor[i] + 'hold', [i]); // Holds
						animation.add(dataColor[i] + 'holdend', [i + 4]); // Tails
					}

					setGraphicSize(Std.int(width * CoolUtil.daPixelZoom));
					updateHitbox();
				default:
					frames = PlayState.noteskinSprite;

					for (i in 0...9) // (i in 0...4) // 9 key
					{
						animation.addByPrefix(frameN[1][i] + 'Scroll', frameN[1][i] + '0'); // Normal notes
						animation.addByPrefix(frameN[1][i] + 'hold', frameN[1][i] + ' hold piece'); // Hold
						animation.addByPrefix(frameN[1][i] + 'holdend', frameN[1][i] + ' hold end'); // Tails
					} // dataColor > frameN[1] for 9 key

					setGraphicSize(Std.int(width * noteScale)); // 0.7 > noteScale for 9 key
					updateHitbox();

					antialiasing = FlxG.save.data.antialiasing;
			}
		}

		x += swagWidth * noteData;
		animation.play(frameN[mania][noteData] + 'Scroll'); // dataColor > frameN[mania] for 9 key
		originColor = noteData; // The note's origin color will be checked by its sustain notes

		/*if (FlxG.save.data.stepMania && !isSustainNote && !(PlayState.instance != null ? PlayState.instance.executeModchart : false))
			{
				var col:Int = 0;

				var beatRow = Math.round(beat * 48);

				// STOLEN ETTERNA CODE (IN 2002)

				if (beatRow % (192 / 4) == 0)
					col = quantityColor[0];
				else if (beatRow % (192 / 8) == 0)
					col = quantityColor[2];
				else if (beatRow % (192 / 12) == 0)
					col = quantityColor[4];
				else if (beatRow % (192 / 16) == 0)
					col = quantityColor[6];
				else if (beatRow % (192 / 24) == 0)
					col = quantityColor[4];
				else if (beatRow % (192 / 32) == 0)
					col = quantityColor[4];

				animation.play(dataColor[col] + 'Scroll');
				if (FlxG.save.data.rotateSprites)
				{
					localAngle -= arrowAngles[col];
					localAngle += arrowAngles[noteData];
					originAngle = localAngle;
				}
				originColor = col;
		}*/ // Commented for 9 key

		// we make sure its downscroll and its a SUSTAIN NOTE (aka a trail, not a note)
		// and flip it so it doesn't look weird.
		// THIS DOESN'T FUCKING FLIP THE NOTE, CONTRIBUTERS DON'T JUST COMMENT THIS OUT JESUS
		// then what is this lol
		// BRO IT LITERALLY SAYS IT FLIPS IF ITS A TRAIL AND ITS DOWNSCROLL
		if (FlxG.save.data.downscroll && sustainNote)
			flipY = true;

		var stepHeight = (((0.45 * Conductor.stepCrochet)) * FlxMath.roundDecimal(PlayStateChangeables.scrollSpeed == 1 ? PlayState.SONG.speed : PlayStateChangeables.scrollSpeed,
			2)) / PlayState.songMultiplier;

		if (isSustainNote && prevNote != null)
		{
			noteYOff = Math.round(-stepHeight + swagWidth * 0.5) + FlxG.save.data.offset + PlayState.songOffset;

			noteScore * 0.2;
			alpha = 0.6;

			x += width / 2;

			originColor = prevNote.originColor;
			originAngle = prevNote.originAngle;

			animation.play(frameN[mania][originColor] +
				'holdend'); // This works both for normal colors and quantization colors // dataColor > frameN[mania] for 9 key
			updateHitbox();

			x -= width / 2;

			// if (noteTypeCheck == 'pixel')
			//	x += 30;
			if (inCharter)
				x += 30;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play(frameN[mania][prevNote.originColor] + 'hold'); // dataColor > frameN[mania] for 9 key
				prevNote.updateHitbox();

				prevNote.scale.y *= stepHeight / prevNote.height;
				prevNote.updateHitbox();

				if (antialiasing)
					prevNote.scale.y *= 1.0 + (1.0 / prevNote.frameHeight);
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (!modifiedByLua)
			angle = modAngle + localAngle;
		else
			angle = modAngle;

		if (!modifiedByLua)
		{
			if (!sustainActive)
			{
				alpha = 0.3;
			}
		}

		if (mustPress)
		{
			if (isSustainNote)
			{
				if (strumTime - Conductor.songPosition <= (((166 * Conductor.timeScale) / (PlayState.songMultiplier < 1 ? PlayState.songMultiplier : 1) * 0.5))
					&& strumTime - Conductor.songPosition >= (((-166 * Conductor.timeScale) / (PlayState.songMultiplier < 1 ? PlayState.songMultiplier : 1))))
					canBeHit = true;
				else
					canBeHit = false;
			}
			else
			{
				if (strumTime - Conductor.songPosition <= (((166 * Conductor.timeScale) / (PlayState.songMultiplier < 1 ? PlayState.songMultiplier : 1)))
					&& strumTime - Conductor.songPosition >= (((-166 * Conductor.timeScale) / (PlayState.songMultiplier < 1 ? PlayState.songMultiplier : 1))))
					canBeHit = true;
				else
					canBeHit = false;
			}
			/*if (strumTime - Conductor.songPosition < (-166 * Conductor.timeScale) && !wasGoodHit)
				tooLate = true; */
		}
		else
		{
			canBeHit = false;
			// if (strumTime <= Conductor.songPosition)
			//	wasGoodHit = true;
		}

		if (tooLate && !wasGoodHit)
		{
			if (alpha > 0.3)
				alpha = 0.3;
		}
	}
}
