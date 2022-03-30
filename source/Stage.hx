package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class Stage extends MusicBeatState
{
	public var curStage:String = '';
	public var camZoom:Float; // The zoom of the camera to have at the start of the game
	public var hideLastBG:Bool = false; // True = hide last BGs and show ones from slowBacks on certain step, False = Toggle visibility of BGs from SlowBacks on certain step
	// Use visible property to manage if BG would be visible or not at the start of the game
	public var tweenDuration:Float = 2; // How long will it tween hiding/showing BGs, variable above must be set to True for tween to activate
	public var toAdd:Array<Dynamic> = []; // Add BGs on stage startup, load BG in by using "toAdd.push(bgVar);"
	// Layering algorithm for noobs: Everything loads by the method of "On Top", example: You load wall first(Every other added BG layers on it), then you load road(comes on top of wall and doesn't clip through it), then loading street lights(comes on top of wall and road)
	public var swagBacks:Map<String,
		Dynamic> = []; // Store BGs here to use them later (for example with slowBacks, using your custom stage event or to adjust position in stage debug menu(press 8 while in PlayState with debug build of the game))
	public var swagGroup:Map<String, FlxTypedGroup<Dynamic>> = []; // Store Groups
	public var animatedBacks:Array<FlxSprite> = []; // Store animated backgrounds and make them play animation(Animation must be named Idle!! Else use swagGroup/swagBacks and script it in stepHit/beatHit function of this file!!)
	public var layInFront:Array<Array<FlxSprite>> = [[], [], []]; // BG layering, format: first [0] - in front of GF, second [1] - in front of opponent, third [2] - in front of boyfriend(and technically also opponent since Haxe layering moment)
	public var slowBacks:Map<Int,
		Array<FlxSprite>> = []; // Change/add/remove backgrounds mid song! Format: "slowBacks[StepToBeActivated] = [Sprites,To,Be,Changed,Or,Added];"

	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// BGs still must be added by using toAdd Array for them to show in game after slowBacks take effect!!
	// All of the above must be set or used in your stage case code block!!
	public var positions:Map<String, Map<String, Array<Int>>> = [
		// Assign your characters positions on stage here!
		'halloween' => [
			'spooky' => [100, 300],
			'monster' => [100, 200],
			'monsterclassic' => [0, 100],
			'dadrockstar' => [-50, 90],
			'dhark' => [85, 170],
			'dharky' => [830, 160],
			'eliot' => [140, 240]
		],
		'philly' => ['pico' => [100, 400], 'griff' => [100, 400]],
		'limo' => ['bf-car' => [1030, 230], 'bf' => [1030, 230], 'big' => [1030, 230]],
		'wainbowbwide' => ['bf-car' => [1030, 230], 'bf' => [1030, 230], 'big' => [1030, 230]],
		'mall' => ['bf-christmas' => [970, 450], 'parents-christmas' => [-400, 100]],
		'mallEvil' => [
			'bf-christmas' => [1090, 450],
			'monster-christmas' => [100, 150],
			'monsterclassic' => [0, 100],
			'dhark' => [0, 100],
			'dharky' => [830, 160]
		],
		'school' => [
			'gf-pixel' => [580, 430],
			'bf-pixel' => [970, 670],
			'senpai' => [250, 460],
			'senpai-angry' => [250, 460],
			'bf' => [0, 50]
		],
		'schoolEvil' => [
			'gf-pixel' => [580, 430],
			'bf-pixel' => [970, 670],
			'spirit' => [-50, 200],
			'bf' => [0, 50]
		],
		'blockshowcase' => [
			'gf-pixel' => [580, 430],
			'bf-pixel' => [970, 670],
			'senpai' => [250, 460],
			'senpai-angry' => [250, 460],
			'spirit' => [-50, 200],
			'bf' => [0, 50]
		],
		'blockshowcaseevil' => [
			'gf-pixel' => [580, 430],
			'bf-pixel' => [970, 670],
			'senpai' => [250, 460],
			'senpai-angry' => [250, 460],
			'spirit' => [-50, 200],
			'bf' => [0, 50]
		],
		// 'village' => ['djprince' => [690, 70], 'villager' => [350, 80]], // 'djprince' => [700, 70], 'villager' => [150, 80]
		'village' => ['djprince' => [660, 0], 'villager' => [-180, 0], 'singingprincess' => [470, 45]], // 'djprince' => [700, 70], 'villager' => [150, 80]
		'auditorHell' => ['bf' => [1175, 280]], // Tricky
		'bloons' => ['loweffortquincy' => [40, -65]],
		'murderinstage' => [
			'stevexg' => [160, 368], 'tankman' => [180, 280], 'griff' => [160, 368], 'xg' => [220, 50], 'harp' => [200, 10], 'bfpixelenemy' => [385, 600],
			'bfenemy' => [175, 450], 'dadrockstar' => [-50, 90], 'gene' => [160, 75], 'dhark' => [0, 100], 'dharky' => [830, 160], 'bubbohd' => [120, 500],
			'oddubhd' => [120, 500], 'ex2x' => [100, 30], 'bg3andjoseph' => [-50, 60], 'noiah' => [110, 70], 'djkirby' => [100, 290], 'abf' => [990, 560],
			'loweffortquincy' => [40, -65], 'singingprincess' => [470, 45], 'eliot' => [140, 240]],
		'stage' => [
			'stevexg' => [160, 368], 'tankman' => [180, 280], 'griff' => [160, 368], 'xg' => [220, 50], 'harp' => [200, 10], 'bfpixelenemy' => [385, 600],
			'bfenemy' => [175, 450], 'dadrockstar' => [-50, 90], 'gene' => [160, 75], 'dhark' => [0, 100], 'dharky' => [830, 160], 'bubbohd' => [120, 500],
			'oddubhd' => [120, 500], 'ex2x' => [100, 30], 'bg3andjoseph' => [-50, 60], 'noiah' => [110, 70], 'djkirby' => [100, 290], 'abf' => [990, 560],
			'loweffortquincy' => [40, -65], 'singingprincess' => [470, 45], 'eliot' => [140, 240], 'kleadron' => [310, 580]]
	];

	// 'stage' => [
	// 	'stevexg' => [150, 340],
	// 	'tankman' => [0, 180],
	// 	'griff' => [400, 130], // 'griff' => [100, 400],
	// 	'xg' => [400, 0],
	// 	'harp' => [410, 130]
	public function new(daStage:String)
	{
		super();
		this.curStage = daStage;
		camZoom = 1.05; // Don't change zoom here, unless you want to change zoom of every stage that doesn't have custom one
		if (PlayStateChangeables.Optimize)
			return;

		switch (daStage)
		{
			case 'halloween':
				{
					var hallowTex = Paths.getSparrowAtlas('halloween_bg', 'week2');

					var halloweenBG = new FlxSprite(-200, -80);
					halloweenBG.frames = hallowTex;
					halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
					halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
					halloweenBG.animation.play('idle');
					halloweenBG.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['halloweenBG'] = halloweenBG;
					toAdd.push(halloweenBG);
				}
			case 'alley': // Stolen From Whitty
				{
					camZoom = 0.9;
					var bg:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('whittyBack', 'week6'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('whittyFront', 'week6'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);
				}
			case 'murderinalley': // Stolen From Whitty
				{
					camZoom = 0.9;
					var bg:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('AlleyBack', 'week6'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('AlleyFront', 'week6'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);
				}
			case 'ballisticAlley': // Stolen From Whitty
				{
					camZoom = 0.9;
					var hallowTex = Paths.getSparrowAtlas('BallisticBackground', 'week6');

					var wbg:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('whittyBack', 'week6'));
					wbg.antialiasing = FlxG.save.data.antialiasing;

					var bg = new FlxSprite(-600, -200);
					bg.frames = hallowTex;
					bg.animation.addByPrefix('idle', 'Background Whitty Moving', 16, true);
					bg.animation.play('idle');
					bg.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					bg.scrollFactor.set(0.9, 0.9);
					bg.active = true;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('whittyFront', 'week6'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var effect = new FlxSprite(-600, -200).loadGraphic(Paths.loadImage('thefunnyeffect', 'week6'));
					effect.alpha = 0.5;
					effect.scrollFactor.set();
					toAdd.push(effect);
				}
			case 'auditorHell': // Stolen from Tricky
				{
					camZoom = 0.55;

					var hole:FlxSprite = new FlxSprite(50, 530).loadGraphic(Paths.loadImage('Spawnhole_Ground_BACK', 'week3'));

					var bg = new FlxSprite(-10, -10).loadGraphic(Paths.loadImage('bg', 'week3'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 4));
					toAdd.push(bg);

					hole.antialiasing = FlxG.save.data.antialiasing;
					hole.scrollFactor.set(0.9, 0.9);
					hole.setGraphicSize(Std.int(hole.width * 1.55));

					var energyWall:FlxSprite = new FlxSprite(1350, -690).loadGraphic(Paths.loadImage('Energywall', 'week3'));
					energyWall.antialiasing = FlxG.save.data.antialiasing;
					energyWall.scrollFactor.set(0.9, 0.9);
					toAdd.push(energyWall);

					var stageFront:FlxSprite = new FlxSprite(-350, -355).loadGraphic(Paths.loadImage('daBackground', 'week3'));
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.55));
					toAdd.push(stageFront);

					toAdd.push(hole);
				} // End of Stolen Tricky Stuff
			case 'village':
				{
					var villageTex = Paths.getSparrowAtlas('village', 'week6');

					var village = new FlxSprite(-380, 0); //-380
					village.frames = villageTex;
					village.animation.addByPrefix('idle', 'Village BG0');
					village.animation.play('idle');
					village.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['village'] = village;
					toAdd.push(village);

					var villageChar = new FlxSprite(-75, 0);
					villageChar.frames = Paths.getSparrowAtlas('Background_chars', 'week6');
					villageChar.animation.addByPrefix('idle', "Dance", 24, false);
					villageChar.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['villageChar'] = villageChar;
					toAdd.push(villageChar);
					animatedBacks.push(villageChar);

					// var villageChar:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('Background_chars'));
					// villageChar.antialiasing = FlxG.save.data.antialiasing;
					// villageChar.active = false;
					// toAdd.push(villageChar);

					// var bgGirls = new BackgroundGirls(-100, 190);
					// bgGirls.scrollFactor.set(0.9, 0.9);
					// bgGirls.setGraphicSize(Std.int(bgGirls.width * PlayState.daPixelZoom));
					// bgGirls.updateHitbox();
					// swagBacks['bgGirls'] = bgGirls;
					// toAdd.push(bgGirls);
				}
			case 'bloons':
				{
					camZoom = 0.9;
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.loadImage('BloonsBackground', 'week6'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('BloonsFloor', 'week6'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var repositionShit = -200;

					var bloonsLogs:FlxSprite = new FlxSprite(repositionShit + 85, 343).loadGraphic(Paths.loadImage('BloonsLogs', 'week6'));
					bloonsLogs.setGraphicSize(Std.int(bloonsLogs.width * 0.75));
					bloonsLogs.antialiasing = FlxG.save.data.antialiasing;
					bloonsLogs.updateHitbox();
					bloonsLogs.scrollFactor.set(0.9, 0.9);
					swagBacks['bloonsLogs'] = bloonsLogs;
					toAdd.push(bloonsLogs);

					var bloons = new FlxSprite(0, 0);
					bloons.frames = Paths.getSparrowAtlas('Bloons', 'week6');
					bloons.antialiasing = FlxG.save.data.antialiasing;
					bloons.setGraphicSize(Std.int(bloons.width * 1.75));
					bloons.animation.addByPrefix('red', "Red Bloon", 24, false);
					bloons.animation.addByPrefix('blue', "Blue Bloon", 24, false);
					bloons.animation.addByPrefix('green', "Green Bloon", 24, false);
					bloons.animation.addByPrefix('yellow', "Yellow Bloon", 24, false);
					bloons.scrollFactor.set(0.85, 0.85);

					bloons.visible = false;

					if (FlxG.save.data.distractions)
					{
						swagBacks['bloons'] = bloons;
						layInFront[2].push(bloons);
						resetBloons();
					}

					if (FlxG.random.bool(25))
						bloons.animation.play('red');
					else if (FlxG.random.bool(25))
						bloons.animation.play('blue');
					else if (FlxG.random.bool(25))
						bloons.animation.play('green');
					else
						bloons.animation.play('yellow');
					// bloons.animation.play(bloons[FlxG.random.int(0, bloons.length - 1)]);
				}
			case 'wainbowbwidge':
				{
					camZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.loadImage('limoSunset', 'week6'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['skyBG'] = skyBG;
					toAdd.push(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('BackgroundPath', 'week6');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['bgLimo'] = bgLimo;
					toAdd.push(bgLimo);

					var fastCar:FlxSprite;
					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.loadImage('TLDMurderbike', 'week6'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;
					fastCar.visible = false;

					if (FlxG.save.data.distractions)
					{
						swagBacks['fastCar'] = fastCar;
						layInFront[2].push(fastCar);
						resetFastCar();
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.loadImage('limoOverlay', 'week6'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limoDrive', 'week6');

					var limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;
					layInFront[0].push(limo);
					swagBacks['limo'] = limo;
				}
			case 'blockshowcase':
				{
					var bgSky = new FlxSprite().loadGraphic(Paths.loadImage('weebSky', 'week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					swagBacks['bgSky'] = bgSky;
					toAdd.push(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.loadImage('weebSchool', 'week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					swagBacks['bgSchool'] = bgSchool;
					toAdd.push(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.loadImage('weebStreet', 'week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					swagBacks['bgStreet'] = bgStreet;
					toAdd.push(bgStreet);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);

					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();

					var bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					// if (PlayState.SONG.songId.toLowerCase() == 'roses')
					if (GameplayCustomizeState.freeplaySong == 'roses')
					{
						if (FlxG.save.data.distractions)
							bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * CoolUtil.daPixelZoom));
					bgGirls.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						swagBacks['bgGirls'] = bgGirls;
						toAdd.push(bgGirls);
					}
				}
			case 'blockshowcaseevil':
				{
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('animatedEvilSchool', 'week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					swagBacks['bg'] = bg;
					toAdd.push(bg);
				}
			case 'murderinstage':
				{
					camZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.loadImage('MurderinStageBack', 'week6'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('MurderinStageFront', 'week6'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('MurderinStageCurtains', 'week6'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = FlxG.save.data.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					swagBacks['stageCurtains'] = stageCurtains;
					toAdd.push(stageCurtains);
				}
			case 'philly':
				{
					var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.loadImage('philly/sky', 'week3'));
					bg.scrollFactor.set(0.1, 0.1);
					bg.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.loadImage('philly/city', 'week3'));
					city.scrollFactor.set(0.3, 0.3);
					city.setGraphicSize(Std.int(city.width * 0.85));
					city.updateHitbox();
					city.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['city'] = city;
					toAdd.push(city);

					var phillyCityLights = new FlxTypedGroup<FlxSprite>();
					if (FlxG.save.data.distractions)
					{
						swagGroup['phillyCityLights'] = phillyCityLights;
						toAdd.push(phillyCityLights);
					}

					for (i in 0...5)
					{
						var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.loadImage('philly/win' + i, 'week3'));
						light.scrollFactor.set(0.3, 0.3);
						light.visible = false;
						light.setGraphicSize(Std.int(light.width * 0.85));
						light.updateHitbox();
						light.antialiasing = FlxG.save.data.antialiasing;
						phillyCityLights.add(light);
					}

					var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.loadImage('philly/behindTrain', 'week3'));
					streetBehind.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['streetBehind'] = streetBehind;
					toAdd.push(streetBehind);

					var phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.loadImage('philly/train', 'week3'));
					phillyTrain.antialiasing = FlxG.save.data.antialiasing;
					if (FlxG.save.data.distractions)
					{
						swagBacks['phillyTrain'] = phillyTrain;
						toAdd.push(phillyTrain);
					}

					trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes', 'shared'));
					FlxG.sound.list.add(trainSound);

					// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

					var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.loadImage('philly/street', 'week3'));
					street.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['street'] = street;
					toAdd.push(street);
				}
			case 'limo':
				{
					camZoom = 0.90;

					var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.loadImage('limo/limoSunset', 'week4'));
					skyBG.scrollFactor.set(0.1, 0.1);
					skyBG.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['skyBG'] = skyBG;
					toAdd.push(skyBG);

					var bgLimo:FlxSprite = new FlxSprite(-200, 480);
					bgLimo.frames = Paths.getSparrowAtlas('limo/bgLimo', 'week4');
					bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
					bgLimo.animation.play('drive');
					bgLimo.scrollFactor.set(0.4, 0.4);
					bgLimo.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['bgLimo'] = bgLimo;
					toAdd.push(bgLimo);

					var fastCar:FlxSprite;
					fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.loadImage('limo/fastCarLol', 'week4'));
					fastCar.antialiasing = FlxG.save.data.antialiasing;
					fastCar.visible = false;

					if (FlxG.save.data.distractions)
					{
						var grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						swagGroup['grpLimoDancers'] = grpLimoDancers;
						toAdd.push(grpLimoDancers);

						for (i in 0...5)
						{
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
							dancer.scrollFactor.set(0.4, 0.4);
							grpLimoDancers.add(dancer);
							swagBacks['dancer' + i] = dancer;
						}

						swagBacks['fastCar'] = fastCar;
						layInFront[2].push(fastCar);
						resetFastCar();
					}

					var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.loadImage('limo/limoOverlay', 'week4'));
					overlayShit.alpha = 0.5;
					// add(overlayShit);

					// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

					// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

					// overlayShit.shader = shaderBullshit;

					var limoTex = Paths.getSparrowAtlas('limo/limoDrive', 'week4');

					var limo = new FlxSprite(-120, 550);
					limo.frames = limoTex;
					limo.animation.addByPrefix('drive', "Limo stage", 24);
					limo.animation.play('drive');
					limo.antialiasing = FlxG.save.data.antialiasing;
					layInFront[0].push(limo);
					swagBacks['limo'] = limo;
				}
			case 'mall':
				{
					camZoom = 0.80;

					var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.loadImage('christmas/bgWalls', 'week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var upperBoppers = new FlxSprite(-240, -90);
					upperBoppers.frames = Paths.getSparrowAtlas('christmas/upperBop', 'week5');
					upperBoppers.animation.addByPrefix('idle', "Upper Crowd Bob", 24, false);
					upperBoppers.antialiasing = FlxG.save.data.antialiasing;
					upperBoppers.scrollFactor.set(0.33, 0.33);
					upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
					upperBoppers.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						swagBacks['upperBoppers'] = upperBoppers;
						toAdd.push(upperBoppers);
						animatedBacks.push(upperBoppers);
					}

					var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.loadImage('christmas/bgEscalator', 'week5'));
					bgEscalator.antialiasing = FlxG.save.data.antialiasing;
					bgEscalator.scrollFactor.set(0.3, 0.3);
					bgEscalator.active = false;
					bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
					bgEscalator.updateHitbox();
					swagBacks['bgEscalator'] = bgEscalator;
					toAdd.push(bgEscalator);

					var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.loadImage('christmas/christmasTree', 'week5'));
					tree.antialiasing = FlxG.save.data.antialiasing;
					tree.scrollFactor.set(0.40, 0.40);
					swagBacks['tree'] = tree;
					toAdd.push(tree);

					var bottomBoppers = new FlxSprite(-300, 140);
					bottomBoppers.frames = Paths.getSparrowAtlas('christmas/bottomBop', 'week5');
					bottomBoppers.animation.addByPrefix('idle', 'Bottom Level Boppers', 24, false);
					bottomBoppers.antialiasing = FlxG.save.data.antialiasing;
					bottomBoppers.scrollFactor.set(0.9, 0.9);
					bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
					bottomBoppers.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						swagBacks['bottomBoppers'] = bottomBoppers;
						toAdd.push(bottomBoppers);
						animatedBacks.push(bottomBoppers);
					}

					var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.loadImage('christmas/fgSnow', 'week5'));
					fgSnow.active = false;
					fgSnow.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['fgSnow'] = fgSnow;
					toAdd.push(fgSnow);

					var santa = new FlxSprite(-840, 150);
					santa.frames = Paths.getSparrowAtlas('christmas/santa', 'week5');
					santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
					santa.antialiasing = FlxG.save.data.antialiasing;
					if (FlxG.save.data.distractions)
					{
						swagBacks['santa'] = santa;
						toAdd.push(santa);
						animatedBacks.push(santa);
					}
				}
			case 'mallEvil':
				{
					var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.loadImage('christmas/evilBG', 'week5'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.2, 0.2);
					bg.active = false;
					bg.setGraphicSize(Std.int(bg.width * 0.8));
					bg.updateHitbox();
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.loadImage('christmas/evilTree', 'week5'));
					evilTree.antialiasing = FlxG.save.data.antialiasing;
					evilTree.scrollFactor.set(0.2, 0.2);
					swagBacks['evilTree'] = evilTree;
					toAdd.push(evilTree);

					var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.loadImage("christmas/evilSnow", 'week5'));
					evilSnow.antialiasing = FlxG.save.data.antialiasing;
					swagBacks['evilSnow'] = evilSnow;
					toAdd.push(evilSnow);
				}
			case 'school':
				{
					// defaultCamZoom = 0.9;

					var bgSky = new FlxSprite().loadGraphic(Paths.loadImage('weeb/weebSky', 'week6'));
					bgSky.scrollFactor.set(0.1, 0.1);
					swagBacks['bgSky'] = bgSky;
					toAdd.push(bgSky);

					var repositionShit = -200;

					var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.loadImage('weeb/weebSchool', 'week6'));
					bgSchool.scrollFactor.set(0.6, 0.90);
					swagBacks['bgSchool'] = bgSchool;
					toAdd.push(bgSchool);

					var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.loadImage('weeb/weebStreet', 'week6'));
					bgStreet.scrollFactor.set(0.95, 0.95);
					swagBacks['bgStreet'] = bgStreet;
					toAdd.push(bgStreet);

					var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.loadImage('weeb/weebTreesBack', 'week6'));
					fgTrees.scrollFactor.set(0.9, 0.9);
					swagBacks['fgTrees'] = fgTrees;
					toAdd.push(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
					var treetex = Paths.getPackerAtlas('weeb/weebTrees', 'week6');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					swagBacks['bgTrees'] = bgTrees;
					toAdd.push(bgTrees);

					var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
					treeLeaves.frames = Paths.getSparrowAtlas('weeb/petals', 'week6');
					treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
					treeLeaves.animation.play('leaves');
					treeLeaves.scrollFactor.set(0.85, 0.85);
					swagBacks['treeLeaves'] = treeLeaves;
					toAdd.push(treeLeaves);

					var widShit = Std.int(bgSky.width * 6);

					bgSky.setGraphicSize(widShit);
					bgSchool.setGraphicSize(widShit);
					bgStreet.setGraphicSize(widShit);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					treeLeaves.setGraphicSize(widShit);

					fgTrees.updateHitbox();
					bgSky.updateHitbox();
					bgSchool.updateHitbox();
					bgStreet.updateHitbox();
					bgTrees.updateHitbox();
					treeLeaves.updateHitbox();

					var bgGirls = new BackgroundGirls(-100, 190);
					bgGirls.scrollFactor.set(0.9, 0.9);

					// if (PlayState.SONG.songId.toLowerCase() == 'roses')
					if (GameplayCustomizeState.freeplaySong == 'roses')
					{
						if (FlxG.save.data.distractions)
							bgGirls.getScared();
					}

					bgGirls.setGraphicSize(Std.int(bgGirls.width * CoolUtil.daPixelZoom));
					bgGirls.updateHitbox();
					if (FlxG.save.data.distractions)
					{
						swagBacks['bgGirls'] = bgGirls;
						toAdd.push(bgGirls);
					}
				}
			case 'schoolEvil':
				{
					var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
					var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

					var posX = 400;
					var posY = 200;

					var bg:FlxSprite = new FlxSprite(posX, posY);
					bg.frames = Paths.getSparrowAtlas('weeb/animatedEvilSchool', 'week6');
					bg.animation.addByPrefix('idle', 'background 2', 24);
					bg.animation.play('idle');
					bg.scrollFactor.set(0.8, 0.9);
					bg.scale.set(6, 6);
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					/* 
						var bg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.loadImage('weeb/evilSchoolBG'));
						bg.scale.set(6, 6);
						// bg.setGraphicSize(Std.int(bg.width * 6));
						// bg.updateHitbox();
						add(bg);
						var fg:FlxSprite = new FlxSprite(posX, posY).loadGraphic(Paths.loadImage('weeb/evilSchoolFG'));
						fg.scale.set(6, 6);
						// fg.setGraphicSize(Std.int(fg.width * 6));
						// fg.updateHitbox();
						add(fg);
						wiggleShit.effectType = WiggleEffectType.DREAMY;
						wiggleShit.waveAmplitude = 0.01;
						wiggleShit.waveFrequency = 60;
						wiggleShit.waveSpeed = 0.8;
					 */

					// bg.shader = wiggleShit.shader;
					// fg.shader = wiggleShit.shader;

					/* 
						var waveSprite = new FlxEffectSprite(bg, [waveEffectBG]);
						var waveSpriteFG = new FlxEffectSprite(fg, [waveEffectFG]);
						// Using scale since setGraphicSize() doesnt work???
						waveSprite.scale.set(6, 6);
						waveSpriteFG.scale.set(6, 6);
						waveSprite.setPosition(posX, posY);
						waveSpriteFG.setPosition(posX, posY);
						waveSprite.scrollFactor.set(0.7, 0.8);
						waveSpriteFG.scrollFactor.set(0.9, 0.8);
						// waveSprite.setGraphicSize(Std.int(waveSprite.width * 6));
						// waveSprite.updateHitbox();
						// waveSpriteFG.setGraphicSize(Std.int(fg.width * 6));
						// waveSpriteFG.updateHitbox();
						add(waveSprite);
						add(waveSpriteFG);
					 */
				}
			default:
				{
					camZoom = 0.9;
					curStage = 'stage';
					var bg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Paths.loadImage('stageback', 'shared'));
					bg.antialiasing = FlxG.save.data.antialiasing;
					bg.scrollFactor.set(0.9, 0.9);
					bg.active = false;
					swagBacks['bg'] = bg;
					toAdd.push(bg);

					var stageFront:FlxSprite = new FlxSprite(-650, 600).loadGraphic(Paths.loadImage('stagefront', 'shared'));
					stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
					stageFront.updateHitbox();
					stageFront.antialiasing = FlxG.save.data.antialiasing;
					stageFront.scrollFactor.set(0.9, 0.9);
					stageFront.active = false;
					swagBacks['stageFront'] = stageFront;
					toAdd.push(stageFront);

					var stageCurtains:FlxSprite = new FlxSprite(-500, -300).loadGraphic(Paths.loadImage('stagecurtains', 'shared'));
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					stageCurtains.antialiasing = FlxG.save.data.antialiasing;
					stageCurtains.scrollFactor.set(1.3, 1.3);
					stageCurtains.active = false;

					swagBacks['stageCurtains'] = stageCurtains;
					toAdd.push(stageCurtains);
				}
		}
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case 'philly':
					if (trainMoving)
					{
						trainFrameTiming += elapsed;

						if (trainFrameTiming >= 1 / 24)
						{
							updateTrainPos();
							trainFrameTiming = 0;
						}
					}
					// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
			}
		}
	}

	override function stepHit()
	{
		super.stepHit();

		if (!PlayStateChangeables.Optimize)
		{
			var array = slowBacks[curStep];
			if (array != null && array.length > 0)
			{
				if (hideLastBG)
				{
					for (bg in swagBacks)
					{
						if (!array.contains(bg))
						{
							var tween = FlxTween.tween(bg, {alpha: 0}, tweenDuration, {
								onComplete: function(tween:FlxTween):Void
								{
									bg.visible = false;
								}
							});
						}
					}
					for (bg in array)
					{
						bg.visible = true;
						FlxTween.tween(bg, {alpha: 1}, tweenDuration);
					}
				}
				else
				{
					for (bg in array)
						bg.visible = !bg.visible;
				}
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();

		if (FlxG.save.data.distractions && animatedBacks.length > 0)
		{
			for (bg in animatedBacks)
				bg.animation.play('idle', true);
		}

		if (!PlayStateChangeables.Optimize)
		{
			switch (curStage)
			{
				case 'halloween':
					if (FlxG.random.bool(Conductor.bpm > 320 ? 100 : 10) && curBeat > lightningStrikeBeat + lightningOffset)
					{
						if (FlxG.save.data.distractions)
						{
							lightningStrikeShit();
							trace('spooky');
						}
					}
				case 'school', 'blockshowcase':
					if (FlxG.save.data.distractions)
					{
						swagBacks['bgGirls'].dance();
					}
				case 'limo':
					if (FlxG.save.data.distractions)
					{
						swagGroup['grpLimoDancers'].forEach(function(dancer:BackgroundDancer)
						{
							dancer.dance();
						});

						if (FlxG.random.bool(10) && fastCarCanDrive)
							fastCarDrive();
					}
				case 'bloons':
					if (FlxG.save.data.distractions)
					{
						if (FlxG.random.bool(10) && bloonsCanMove)
							bloonsMove();
					}
				case "philly":
					if (FlxG.save.data.distractions)
					{
						if (!trainMoving)
							trainCooldown += 1;

						if (curBeat % 4 == 0)
						{
							var phillyCityLights = swagGroup['phillyCityLights'];
							phillyCityLights.forEach(function(light:FlxSprite)
							{
								light.visible = false;
							});

							curLight = FlxG.random.int(0, phillyCityLights.length - 1);

							phillyCityLights.members[curLight].visible = true;
							// phillyCityLights.members[curLight].alpha = 1;
						}
					}

					if (curBeat % 8 == 4 && FlxG.random.bool(Conductor.bpm > 320 ? 150 : 30) && !trainMoving && trainCooldown > 8)
					{
						if (FlxG.save.data.distractions)
						{
							trainCooldown = FlxG.random.int(-4, 0);
							trainStart();
							trace('train');
						}
					}
			}
		}
	}

	// Variables and Functions for Stages
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var curLight:Int = 0;

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2, 'shared'));
		swagBacks['halloweenBG'].animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (PlayState.boyfriend != null)
		{
			PlayState.boyfriend.playAnim('scared', true);
			PlayState.gf.playAnim('scared', true);
		}
		else
		{
			GameplayCustomizeState.boyfriend.playAnim('scared', true);
			GameplayCustomizeState.gf.playAnim('scared', true);
		}
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;
	var trainSound:FlxSound;

	function trainStart():Void
	{
		if (FlxG.save.data.distractions)
		{
			trainMoving = true;
			trainSound.play(true);
		}
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (trainSound.time >= 4700)
			{
				startedMoving = true;

				if (PlayState.gf != null)
					PlayState.gf.playAnim('hairBlow');
				else
					GameplayCustomizeState.gf.playAnim('hairBlow');
			}

			if (startedMoving)
			{
				var phillyTrain = swagBacks['phillyTrain'];
				phillyTrain.x -= 400;

				if (phillyTrain.x < -2000 && !trainFinishing)
				{
					phillyTrain.x = -1150;
					trainCars -= 1;

					if (trainCars <= 0)
						trainFinishing = true;
				}

				if (phillyTrain.x < -4000 && trainFinishing)
					trainReset();
			}
		}
	}

	function trainReset():Void
	{
		if (FlxG.save.data.distractions)
		{
			if (PlayState.gf != null)
				PlayState.gf.playAnim('hairFall');
			else
				GameplayCustomizeState.gf.playAnim('hairFall');

			swagBacks['phillyTrain'].x = FlxG.width + 200;
			trainMoving = false;
			// trainSound.stop();
			// trainSound.time = 0;
			trainCars = 8;
			trainFinishing = false;
			startedMoving = false;
		}
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		if (FlxG.save.data.distractions)
		{
			var fastCar = swagBacks['fastCar'];
			fastCar.x = -12600;
			fastCar.y = FlxG.random.int(140, 250);
			fastCar.velocity.x = 0;
			fastCar.visible = false;
			fastCarCanDrive = true;
		}
	}

	function fastCarDrive()
	{
		if (FlxG.save.data.distractions)
		{
			FlxG.sound.play(Paths.soundRandom('carPass', 0, 1, 'shared'), 0.7);

			swagBacks['fastCar'].visible = true;
			swagBacks['fastCar'].velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
			fastCarCanDrive = false;
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				resetFastCar();
			});
		}
	}

	var bloonsCanMove:Bool = true;

	function resetBloons():Void
	{
		if (FlxG.save.data.distractions)
		{
			var bloons = swagBacks['bloons'];
			bloons.x = -350;
			bloons.y = 350;
			bloons.velocity.x = 0;
			bloons.visible = false;
			bloonsCanMove = true;
		}
	}

	function bloonsMove()
	{
		if (FlxG.save.data.distractions)
		{
			swagBacks['bloons'].visible = true;
			swagBacks['bloons'].velocity.x = (FlxG.random.int(300, 500));
			bloonsCanMove = false;
			new FlxTimer().start(10, function(tmr:FlxTimer)
			{
				resetBloons();
			});
		}
	}
}
