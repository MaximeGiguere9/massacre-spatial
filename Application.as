﻿package  {
	import flash.net.URLRequest;
	import flash.display.Loader;
	
		//ce qui est écrit
		public var projectilesJoueur:Array;
		public var ennemis:Array;
		public var projectiles:Array;
		public var score:Number;
		public var hud:HUD;
		//apparamment on ne peut pas créer de propriétés dynamiques avec Number, donc voici une autre variable
		public var scoreCombo:Number;
		//arrière-plan
		public var loaderFond:Loader;
		//tous les sons
		public var son:Sound;
		//timers
		public var tempsRecharge:Number;
		
			//pré-charge le fond. Celui-ci est converti en png car l'avoir décomposé dans la bibliothèque causait des problèmes sur certains ordinateurs
			this.loaderFond = new Loader();
			this.loaderFond.load(new URLRequest("mediasExternes/fond.png"))
			afficherAccueil();
			//enlève tout pour ne pas laisser de résidus
			while(this.numChildren > 0){this.removeChildAt(0);}	
			//définir l'index manuellement s'assure qu'ils apparaîssent dans le bon ordre
			this.addChildAt(this.loaderFond, 0);
			var accueil = new Splash();
			this.addChildAt(accueil, 1);
			this.son = new Sound(new URLRequest("mediasExternes/ambiance.mp3"));
			this.son.play();
		
			//On a créé un mur, qui commence son animation automatiquement
			//On attend que le mur s'arrête pour afficher le texte	
			if((this.getChildAt(this.numChildren-1) as MovieClip).currentFrame == 30){
				this.texte = new But();
				var boutonRetour = creerBouton("Retour", stage.stageWidth/2- 30, 400);
				this.texte.addChild(boutonRetour);
				this.texte.alpha = 0
				this.texte.present = false;
				this.addChild(this.texte);
				stage.addEventListener(Event.ENTER_FRAME, animTexte);
				stage.removeEventListener(Event.ENTER_FRAME, afficherBut);
			}
		}
		
		function afficherFinJeu(pEvt:Event){
			//on enlève les écouteurs, les ennemis et les projectiles
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, gestionnaireInputJoueur)
			stage.removeEventListener(KeyboardEvent.KEY_UP, gestionnaireInputJoueur)
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame)
			for(var i = this.ennemis.length-1; i >= 0; i--){this.ennemis[i] = null}
			for(var i = this.projectiles.length-1; i >= 0; i--){this.projectiles[i] = null}
			for(var i = this.projectilesJoueur.length-1; i >= 0; i--){this.projectilesJoueur[i] = null}
			
			//On attend que le mur s'arrête pour afficher le texte	
			if((this.getChildAt(this.numChildren-1) as MovieClip).currentFrame == 30){
				this.texte = new Fin();
				var boutonAccueil = creerBouton("Accueil", stage.stageWidth/2- 30, 380);
				var boutonEncore = creerBouton("Recommencer", stage.stageWidth/2- 30, 310);
				this.texte.addChild(boutonAccueil);
				this.texte.addChild(boutonEncore);
				this.texte.alpha = 0
				this.texte.present = false;
				this.texte.txtScore.text = this.score.toString();
				this.addChild(this.texte);
				stage.addEventListener(Event.ENTER_FRAME, animTexte);
				stage.removeEventListener(Event.ENTER_FRAME, afficherFinJeu);
			}
		}
		
			else {bouton.txtBouton.textColor = 0xf5af41;}
				case("Recommencer"):
					demarrerJeu();
				break;
					this.addChild(new Mur())
				break;
				case("Accueil"):
					afficherAccueil();
				(this.getChildAt(this.numChildren-2) as MovieClip).play();
					this.texte = null;
			//enlève tout pour ne pas laisser de résidus, puis rajoute les différents éléments du jeu
			this.joueur.pv = 10;
			this.score = 0;
			this.scoreCombo = 1;
			this.ennemis = new Array();
			this.projectiles = new Array();
			this.projectilesJoueur = new Array();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame)
			//petit secret: le joueur peut aussi être bougé par drag (oui, c'est vraiment juste parce que c'est écrit dans le devis)
			this.joueur.addEventListener(MouseEvent.MOUSE_DOWN, gestionnaireInputJoueurParDrag)
			this.joueur.addEventListener(MouseEvent.MOUSE_UP, gestionnaireInputJoueurParDrag)
		
		function gestionnaireInputJoueurParDrag(pEvt:Event){
			if(pEvt.type == "mouseDown") {this.joueur.startDrag(true)}
			else {this.joueur.stopDrag()}
		}
		
			//l'action prise
			var numTouche = pEvt.keyCode;
			var commande = pEvt.type;
			//touches à vérifier: flèches gauche, haut droite et bas, shift gauche et z
			var touchesCible = [37, 38, 39, 40, 16, 90];
			//propriétés à modifier
			var propCible = ["vaGauche", "vaHaut", "vaDroit", "vaBas", "lent", "tir"];
			//les conditions ne doivent pas être exclusives (else) pour permettre le support de plusieurs touches à la fois
			for(var i = 0; i < touchesCible.length; i++) {
				if(numTouche == touchesCible[i] && commande == "keyDown") {this.joueur[propCible[i]] = true;}
				if(numTouche == touchesCible[i] && commande == "keyUp") {this.joueur[propCible[i]] = false;}
				
			}
		}
		
		function onEnterFrame(pEvt:Event){
			actualiserJoueur();
			gestionEnnemis();
			//actualiser le HUD. Pas assez important pour avoir sa propre fonction
			this.hud.pvJoueur.scaleY = this.joueur.pv/10
			this.hud.barreCombo.scaleY = (this.scoreCombo-1)/10
			this.hud.txtScore.text = this.score.toString();
			this.hud.txtCombo.text = "x" + Math.round(this.scoreCombo);
			if(this.hud.txtCombo.text == "x11"){trace(this.scoreCombo)}
			//diminue le combo. on veut qu'il fluctue le plus possible
			//empêche le combo d'être en bas de x1 pour ne pas enlever de points quand on tue un ennemi 
			if(this.scoreCombo > 1){this.scoreCombo -= 0.01}
		}
	
					else {this.joueur[dirCible[i%2]]+= deplacement[Math.floor(i/2)]*5;}
			
			//empêche de créer des projectiles joueur à chaque image
			this.tempsRecharge++;
			//tir si la touche tir est enfoncée
			if(this.joueur.tir && this.tempsRecharge%6 == 0){
				var nouvProjectile = new PewPew();
				nouvProjectile.x = this.joueur.x;
				nouvProjectile.y = this.joueur.y;
				nouvProjectile.scaleX = nouvProjectile.scaleY = 0.4
				this.projectilesJoueur.push(nouvProjectile);
				this.addChildAt(nouvProjectile, 1);
				//joue l'effet sonore
				this.son = new Sound(new URLRequest("mediasExternes/pew.mp3"));
				this.son.play();	
			}
			
			//actualise les projectiles s'il y a lieu
			if(this.projectilesJoueur.length > 0){
				for(var i = this.projectilesJoueur.length-1; i >= 0; i--){
					var projectileCible = this.projectilesJoueur[i]
					projectileCible.y -=15;
					//test de collision
					for(var j = this.ennemis.length-1; j >= 0; j--){
						var ennemi = this.ennemis[j]
						if(projectileCible.hitTestObject(ennemi.hitbox) && this.contains(projectileCible) && this.contains(ennemi)){
							//si l'ennemi touche un projectile, on enlève les deux et on augmente le score
							//utiliser this.contains ici et ailleurs avant d'enlever l'objet permet de prévenir un bug qui faisait tout planter
							this.score += 10*Math.round(this.scoreCombo)
							//combo maximum de x10.
							if(this.scoreCombo < 9){this.scoreCombo ++}
							else{this.scoreCombo = 10}
							this.removeChild(projectileCible)
							this.projectilesJoueur.splice(i, 1)
							this.removeChild(ennemi)
							this.ennemis.splice(j, 1)
						
						}
					}
					//supprime le projectile s'il sort du stage
					if(projectileCible.y < -5 && this.contains(projectileCible)){
						this.removeChild(projectileCible);
						this.projectilesJoueur.splice(i, 1)
					}
				}
			}
		
			
			//controle l'apparition d'ennemis
			this.tempsEnnemi += Math.random()*2;
			if(this.tempsEnnemi / 20 > 1) {
				this.ennemis.push(creerEnnemi());
				this.addChildAt(this.ennemis[this.ennemis.length-1], 2);
				this.tempsEnnemi -= 20
			}
			
			
			//controle l'apparition de projectiles
			this.tempsTir += Math.random()*this.ennemis.length;
			if(this.tempsTir / 20 > 1) {
				this.projectiles.push(creerTirEnnemi());
				this.addChildAt(this.projectiles[this.projectiles.length-1], 2);
				this.tempsTir -= 20
			}
			
			
			//controle l'actualisation de la position des ennemis, et les enlève du stage si ils ne sont plus dans l'écran
			//comme j'utilise splice dans le millieu d'un array, commencer par la fin évite de rencontrer des problèmes
			if(this.ennemis.length > 0){
				for(var i = this.ennemis.length-1; i >= 0; i--) {
					var ennemiCible = this.ennemis[i]
					if(ennemiCible.cote == "gauche") {ennemiCible.x += 4;} 
					else {ennemiCible.x -= 4;}
					//supprime l'ennemi s'il est en dehors du stage
					if((ennemiCible.x > stage.stageWidth + 100 || ennemiCible.x < -100) && this.contains(ennemiCible)) {
						this.removeChild(ennemiCible)
						this.ennemis.splice(i, 1)
						//combo minimum de x1
						if(this.scoreCombo > 1){this.scoreCombo--}
					}
				}
			}
			
			//controle l'actualisation de la position des projectiles, et les enlève du stage si ils ne sont plus dans l'écran
			//comme j'utilise splice dans le millieu d'un array, commencer par la fin évite de rencontrer des problèmes
			if(this.projectiles.length > 0){
				for(var i = this.projectiles.length-1; i >= 0 ; i--){
					for(var j = this.projectiles[i].numChildren-1; j >= 0; j--){
						var projectileCible = this.projectiles[i].getChildAt(j);
						//multiplie l'incrémentation pour donner plus de vitesse
						projectileCible.x += projectileCible.mouvX*3;
						projectileCible.y += projectileCible.mouvY*3;
						//supprime le projectile s'il est en dehors du stage
						if(projectileCible.x > stage.stageWidth + 100 || projectileCible.x < -100 || projectileCible.y > stage.stageHeight) {
							this.projectiles[i].removeChild(projectileCible)
							//si le conteneur est vide, on l'enlève
							if(this.projectiles[i].numChildren == 0){this.projectiles.splice(i, 1)}
							
						}
						//test de collision
						if(projectileCible.hitTestObject(this.joueur.hitbox)){
						//si le joueur touche un projectile, on enlève le projectile et un point de vie. Si on atteint 0PV, l'écran de fin de jeu apparaît
						this.projectiles[i].removeChild(projectileCible)
						this.joueur.pv --;
						//combo minimum de x1
						if(this.scoreCombo > 1){this.scoreCombo/=2}
						if(this.joueur.pv == 0){
							//on crée un mur pour l'écran de fin de jeu
							this.addChild(new Mur());
							stage.addEventListener(Event.ENTER_FRAME, afficherFinJeu);
						}
					}
					}
				}
			}
			
		}
		
			else {ennemi.cote = "droit";}
			//on adresse un ennemi au hasard pour le faire attaquer
			var conteneurVollee = new Sprite();
			//mes compétences en maths sont un peu rouillées, alors valeurs précises en array
		