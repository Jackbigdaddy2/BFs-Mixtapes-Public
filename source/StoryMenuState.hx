package;

import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
#if FEATURE_DISCORD
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;

	static function weekData():Array<Dynamic>
	{
		return [
			['tutorial'],
			['defiant', 'the-belt', 'end-of-an-era'],
			['expedition', 'accelerated', 'finale'],
			// ['dark-n-deep', 'orientation', 'devastation'],
			['calcium', 'beyond', 'darkside', 'uk'],
			['synergy', 'tempo', 'energetic'],
			['revival', 'benefactor', 'dadbonus', 'rushbf'],
			['nitwit', 'sub', 'tierone', 'tacktrostophy']
		];
	}

	var bf:FlxSprite;
	var dadrockstar:FlxSprite;
	var djprince:FlxSprite;
	var villager:FlxSprite;
	var gene:FlxSprite;
	var eliot:FlxSprite;
	var loweffortquincy:FlxSprite;
	var harp:FlxSprite;
	var gf:FlxSprite;
	var xg:FlxSprite;

	function initCharacters() // Thanks Kleadron.
	{
		bf = new FlxSprite();
		bf.frames = Paths.getSparrowAtlas('characters/BOYFRIEND', 'shared');
		bf.animation.addByPrefix('idle', 'BF idle dance', 24, true);
		bf.antialiasing = FlxG.save.data.antialiasing;
		bf.setGraphicSize(Std.int(bf.width * 0.75));
		bf.updateHitbox();
		bf.visible = false;
		bf.animation.play('idle');
		#if Ultrawide
		bf.x = 949 + 220;
		#else
		bf.x = 949;
		#end
		bf.y = 400;

		dadrockstar = new FlxSprite();
		dadrockstar.frames = Paths.getSparrowAtlas('characters/Dad_Rockstar', 'shared');
		dadrockstar.animation.addByPrefix('idle', 'Young Dad Idle', 24, true);
		dadrockstar.antialiasing = FlxG.save.data.antialiasing;
		dadrockstar.setGraphicSize(Std.int(dadrockstar.width * 0.75));
		dadrockstar.updateHitbox();
		dadrockstar.visible = false;
		dadrockstar.animation.play('idle');
		#if Ultrawide
		dadrockstar.x = 390 + 110;
		#else
		dadrockstar.x = 390;
		#end
		dadrockstar.y = 137;

		djprince = new FlxSprite();
		djprince.frames = Paths.getSparrowAtlas('characters/DJ_Prince', 'shared');
		djprince.animation.addByPrefix('idle', 'DJ Prince Idle Dance', 24, true);
		djprince.antialiasing = FlxG.save.data.antialiasing;
		djprince.setGraphicSize(Std.int(djprince.width * 0.75));
		djprince.updateHitbox();
		djprince.visible = false;
		djprince.animation.play('idle');
		#if Ultrawide
		djprince.x = 780 + 110;
		#else
		djprince.x = 780;
		#end
		djprince.y = 60;

		villager = new FlxSprite();
		villager.frames = Paths.getSparrowAtlas('characters/Villager', 'shared');
		villager.animation.addByPrefix('idle', 'Villager Idle Dance', 24, true);
		villager.antialiasing = FlxG.save.data.antialiasing;
		villager.setGraphicSize(Std.int(villager.width * 0.75));
		villager.updateHitbox();
		villager.visible = false;
		villager.animation.play('idle');
		#if Ultrawide
		villager.x = 290 + 110;
		#else
		villager.x = 290;
		#end
		villager.y = 68;

		gene = new FlxSprite();
		gene.frames = Paths.getSparrowAtlas('characters/gene', 'shared');
		gene.animation.addByPrefix('idle', 'Gene Idle', 24, true);
		gene.antialiasing = FlxG.save.data.antialiasing;
		gene.setGraphicSize(Std.int(gene.width * 0.75));
		gene.updateHitbox();
		gene.visible = false;
		gene.animation.play('idle');
		gene.alpha = 0.7;
		#if Ultrawide
		gene.x = 320 + 110;
		#else
		gene.x = 320;
		#end
		gene.y = 150;

		loweffortquincy = new FlxSprite();
		loweffortquincy.frames = Paths.getSparrowAtlas('characters/LowEffortQuincy', 'shared');
		loweffortquincy.animation.addByPrefix('idle', 'Quincy Idle Dance', 24, true);
		loweffortquincy.antialiasing = FlxG.save.data.antialiasing;
		loweffortquincy.setGraphicSize(Std.int(loweffortquincy.width * 0.8 * 0.75));
		loweffortquincy.updateHitbox();
		loweffortquincy.visible = false;
		loweffortquincy.animation.play('idle');
		loweffortquincy.alpha = 0.7;
		#if Ultrawide
		loweffortquincy.x = 250 + 110;
		#else
		loweffortquincy.x = 250;
		#end
		loweffortquincy.y = 110;

		eliot = new FlxSprite();
		eliot.frames = Paths.getSparrowAtlas('characters/Eliot', 'shared');
		eliot.animation.addByPrefix('idle', 'Eliot Idle Dance', 24, true);
		eliot.antialiasing = FlxG.save.data.antialiasing;
		eliot.setGraphicSize(Std.int(eliot.width * 0.75));
		eliot.updateHitbox();
		eliot.visible = false;
		eliot.animation.play('idle');
		#if Ultrawide
		eliot.x = 440 + 110;
		#else
		eliot.x = 440;
		#end
		eliot.y = 250;

		harp = new FlxSprite();
		harp.frames = Paths.getSparrowAtlas('characters/Harp_assets', 'shared');
		harp.animation.addByPrefix('idle', 'Harp Idle', 24, true);
		harp.antialiasing = FlxG.save.data.antialiasing;
		harp.setGraphicSize(Std.int(harp.width * 0.75));
		harp.updateHitbox();
		harp.visible = false;
		harp.animation.play('idle');
		#if Ultrawide
		harp.x = 510 + 110;
		#else
		harp.x = 510;
		#end
		harp.y = 95;

		gf = new FlxSprite();
		gf.frames = Paths.getSparrowAtlas('characters/GF_assets', 'shared');
		gf.animation.addByPrefix('idle', 'GF Dancing Beat0', 24, true);
		gf.antialiasing = FlxG.save.data.antialiasing;
		gf.setGraphicSize(Std.int(gf.width * 0.75));
		gf.updateHitbox();
		gf.visible = false;
		gf.animation.play('idle');
		#if Ultrawide
		gf.x = 400 + 110;
		#else
		gf.x = 400;
		#end
		gf.y = 225;

		xg = new FlxSprite();
		xg.frames = Paths.getSparrowAtlas('characters/xgtest', 'shared');
		xg.animation.addByPrefix('idle', 'xg idle', 24, true);
		xg.antialiasing = FlxG.save.data.antialiasing;
		xg.setGraphicSize(Std.int(xg.width * 0.75));
		xg.updateHitbox();
		xg.visible = false;
		xg.animation.play('idle');
		xg.alpha = 0.3;
		#if Ultrawide
		xg.x = 325 + 110;
		#else
		xg.x = 325;
		#end
		xg.y = 110;
	}

	function addCharacters()
	{
		add(bf);
		add(gf);
		add(dadrockstar);
		add(harp);
		add(gene);
		add(eliot);
		add(loweffortquincy);
		add(xg);
		add(villager);
		add(djprince);
	}

	#if OneDifficulty
	var curDifficulty:Int = 0;
	#else
	var curDifficulty:Int = 1;
	#end

	public static var weekUnlocked:Array<Bool> = [];

	private var iconArray:Array<HealthIcon> = [];

	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/weekNames'));

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [];
		// #if debug // Comment this if you want to unlock the weeks again
		for (i in 0...weekNames.length)
			weeks.push(true);
		return weeks;
		// #end // This too

		weeks.push(true);

		for (i in 0...FlxG.save.data.weekUnlocked)
		{
			weeks.push(true);
		}
		return weeks;
	}

	override function create()
	{
		weekUnlocked = unlockWeeks();

		PlayState.currentSong = "bruh";
		PlayState.inDaPlay = false;
		#if FEATURE_DISCORD
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(FlxG.random.bool() ? Paths.music('freakyMenu') : Paths.music('freakyMenuOG'));
				Conductor.changeBPM(102);
			}
		}

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

		grpWeekText = new FlxTypedGroup<MenuItem>();

		grpLocks = new FlxTypedGroup<FlxSprite>();

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		trace("Line 70");

		for (i in 0...weekData().length)
		{
			var weekThing:MenuItem = new MenuItem(20, 5, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			// weekThing.screenCenter(X);
			weekThing.antialiasing = FlxG.save.data.antialiasing;
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				trace('locking week ' + i);
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				lock.antialiasing = FlxG.save.data.antialiasing;
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		difficultySelectors = new FlxGroup();
		#if !OneDifficulty
		add(difficultySelectors);
		#end

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.antialiasing = FlxG.save.data.antialiasing;
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		sprDifficulty.antialiasing = FlxG.save.data.antialiasing;
		changeDifficulty();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = FlxG.save.data.antialiasing;
		difficultySelectors.add(rightArrow);

		trace("Line 150");

		txtTracklist = new FlxText(FlxG.width * 0.05, 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		// add(rankText);
		initCharacters();
		addCharacters();

		add(grpWeekText);
		add(grpLocks);

		add(scoreText);
		add(txtWeekTitle);

		add(txtTracklist);

		updateText();

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeWeek(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeWeek(1);
					}

					#if !OneDifficulty
					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
					{
					#end
						rightArrow.animation.play('idle');
					#if !OneDifficulty
					} if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
					{
					#end
						leftArrow.animation.play('idle');
					#if !OneDifficulty
					} if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeDifficulty(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeDifficulty(-1);
					}
					#end
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeWeek(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeWeek(1);
				}

				if (controls.RIGHT)
					rightArrow.animation.play('press')
				else
					rightArrow.animation.play('idle');

				if (controls.LEFT)
					leftArrow.animation.play('press');
				else
					leftArrow.animation.play('idle');

				#if !OneDifficulty
				if (controls.RIGHT_P)
					changeDifficulty(1);
				if (controls.LEFT_P)
					changeDifficulty(-1);
				#end
			}
			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}
		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;
			PlayState.songMultiplier = 1;

			PlayState.isSM = false;

			PlayState.storyDifficulty = curDifficulty;

			#if OneDifficulty
			var diff:String = [""][PlayState.storyDifficulty];
			#else
			var diff:String = ["-easy", "", "-hard"][PlayState.storyDifficulty];
			#end
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.conversionChecks(Song.loadFromJson(PlayState.storyPlaylist[0], diff));
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		#if OneDifficulty
		if (curDifficulty < 0)
			curDifficulty = 0;
		if (curDifficulty > 0)
			curDifficulty = 0;
		#else
		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;
		#end

		sprDifficulty.offset.x = 0;

		#if OneDifficulty
		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
		}
		#else
		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 20;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 70;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 20;
		}
		#end

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = leftArrow.y - 15;
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		curWeek += change;

		if (curWeek >= weekData().length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekData().length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			if (item.targetY == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0.6;
			bullShit++;
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateText()
	{
		bf.visible = false;
		gf.visible = false;
		harp.visible = false;
		dadrockstar.visible = false;
		villager.visible = false;
		djprince.visible = false;
		gene.visible = false;
		eliot.visible = false;
		loweffortquincy.visible = false;
		xg.visible = false;

		switch (curWeek)
		{
			case 0:
				bf.visible = true;
				gf.visible = true;
			case 1:
				dadrockstar.visible = true;
				bf.visible = true;
				#if Ultrawide
				bf.x = 949 + 110;
				#else
				bf.x = 949;
				#end
			case 2:
				bf.visible = true;
				#if Ultrawide
				bf.x -= 280 - 55;
				#else
				bf.x -= 280;
				#end
			case 3:
				harp.visible = true;
				bf.visible = true;
				#if Ultrawide
				bf.x = 949 + 110;
				#else
				bf.x = 949;
				#end
			case 4:
				bf.visible = true;
			case 5:
				eliot.visible = true;
				bf.visible = true;
				gene.visible = true;
			case 6:
				villager.visible = true;
				djprince.visible = true;
				loweffortquincy.visible = true;
				xg.visible = true;
		}

		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		#if Ultrawide
		txtTracklist.x += FlxG.width * 0.35 + 110;
		#else
		txtTracklist.x += FlxG.width * 0.35;
		#end

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}

	public static function unlockNextWeek(week:Int):Void
	{
		if (week <= weekData().length - 1 /*&& FlxG.save.data.weekUnlocked == week*/) // fuck you, unlocks all weeks
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
