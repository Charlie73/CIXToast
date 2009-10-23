package com.cix
{ 	
 	import flash.events.*;
 	import flash.media.Sound;
 	import flash.net.URLRequest;
 	import flash.system.Capabilities;
 	import flash.utils.Timer;
 	
 	import mx.collections.ArrayCollection;
 	import mx.containers.HBox;
 	import mx.containers.VBox;
 	import mx.controls.HRule;
 	import mx.controls.Image;
 	import mx.controls.Label;
 	import mx.controls.Text;
 	import mx.core.Application;
 	import mx.core.Window;
 	import mx.events.FlexEvent;
 	import flash.net.navigateToURL;
 	import mx.controls.Alert;
  
    public class ToastAlert extends Window  
    {  
    	private var _padding:int=8;//the spacing between the alert text and the alert border
    	private var _positionOffset:int;
    	private var _position:String; //TL, TM, TR, ML, MM, MR, BL, BM, BR
        private var _showTimer:Timer;  
        private var _delayTimer:Timer;  
        private var _hideTimer:Timer;  
  
        private var _delayTime:int;
        private var _notifcations:ArrayCollection;
        private var _width:int;  
        private var _height:int;
        private var _maxMessages:int = 5; 
  
    	/**
   		 * notifcations:ArrayCollection - 
   		 * position:String - The position of the ToastAlert, see the variable '_position' for what to pass in
   		 * positionOffset:int - The distance from the side of the screen, ignored when position is 'MM'
  		**/
        public function ToastAlert(notifcations:ArrayCollection, position:String="BR", positionOffset:int=40) {  
          	this._position = position;
          	this._positionOffset = positionOffset;
          	this.alwaysInFront = true;
            this.maximizable = false;
            this.resizable = false;  
            this.minimizable = false;
  			this._notifcations=notifcations;
  			if (_notifcations.length > _maxMessages)
  				this.height = (6 * 108) + 40; //set the height acording to how many widgets there are
  			else
  				this.height = (_notifcations.length * 108) + 40; //set the height acording to how many widgets there are
            
            this.showTitleBar=false;
            this.systemChrome = "none"; // alternate, none, standard, utility 
            this.type = "utility"; // lightweight, normal, utility
            this.setStyle("cornerRadius","0");
            this.addEventListener(FlexEvent.CREATION_COMPLETE, completeHandler);
            //uncomment the line below if you want the application to get focus when you click an alert
            //this.addEventListener(MouseEvent.CLICK, parentFocus);
        }  
  
  		private function parentFocus(event:MouseEvent):void {
  			Application.application.activate();
	        Application.application.nativeApplication.icon.bitmaps = [];// clear the applcation icon from the systray
  		}
  		
        public function completeHandler(event:FlexEvent):void {  
            
            switch(_position)//TopLeft, TopMiddle, TopRight, MiddleRight, MiddleMiddle, BottomRight, BottomMiddle, BottomLeft, MiddleLeft
            {
            	case"TL":
            		this.nativeWindow.x = _positionOffset;
            		this.nativeWindow.y = _positionOffset; 
            		break;
        		case"TM":
        			this.nativeWindow.x = (Capabilities.screenResolutionX / 2) - (this.width / 2);
            		this.nativeWindow.y = _positionOffset;
            		break;            		
        		case"TR":
        			this.nativeWindow.x = Capabilities.screenResolutionX - (this.width + _positionOffset);
            		this.nativeWindow.y = _positionOffset; 
            		break;
            	case"ML":
            		this.nativeWindow.x = _positionOffset;
            		this.nativeWindow.y = (Capabilities.screenResolutionY / 2) - (this.height / 2 );  
            		break;	
	        	case"MM":
        			this.nativeWindow.x = (Capabilities.screenResolutionX / 2) - (this.width / 2);
            		this.nativeWindow.y = (Capabilities.screenResolutionY / 2) - (this.height / 2 ); 
	        		break;
        		case"MR":
        			this.nativeWindow.x = Capabilities.screenResolutionX - (this.width + _positionOffset);
        			this.nativeWindow.y = (Capabilities.screenResolutionY / 2) - (this.height / 2 );
	        		break;
        		case"BL":
        			this.nativeWindow.x = _positionOffset;
            		this.nativeWindow.y = Capabilities.screenResolutionY - (this.height + _positionOffset);  
	        		break;
        		case"BM":
        			this.nativeWindow.x = (Capabilities.screenResolutionX / 2) - (this.width / 2);  
            		this.nativeWindow.y = Capabilities.screenResolutionY - (this.height + _positionOffset);   
	        		break;
        		case"BR":
		            this.nativeWindow.x = Capabilities.screenResolutionX - (this.width + _positionOffset);  
            		this.nativeWindow.y = Capabilities.screenResolutionY - (this.height + _positionOffset);  
	        		break;
            }
            
            this.horizontalScrollPolicy = "off";  
            this.verticalScrollPolicy = "off";  
  
            _showTimer = new Timer(100,0);  
            _showTimer.addEventListener("timer", showTimerHandler);  
            _showTimer.start();  
        }  
  
        public function show(delayTime:int=6, width:int=240): void {  
            var maxMessages:int=5;
            
            _delayTime = delayTime;  
            
          	this.width = width;
          	this.setStyle("backgroundColor", "#313131");
          	this.setStyle("color", "#ffffff");
          	this.setStyle("verticalGap",0);
            this.setStyle("horizontalGap",0);
  
  			var alertSound:Sound = new Sound;
  			alertSound.load(new URLRequest('sound/alert.mp3'));
  			alertSound.play();
  
    		var lblTitle:Label = new Label();
        	lblTitle.text = "CIX alert";
        	lblTitle.width=width;
        	lblTitle.height=42;      	
        	lblTitle.setStyle("fontSize", "12");
        	lblTitle.setStyle("textAlign", "center");
        	lblTitle.setStyle("color", "#dbdbdb");
        	lblTitle.setStyle("paddingTop", 12);
 			
         	var hr1:HRule = new HRule();
 			hr1.width=width;
 			hr1.setStyle("strokeColor", "#222222");
 			hr1.setStyle("shadowColor", "#444444");
 			
        	this.addChild(lblTitle);
        	this.addChild(hr1);
        	
            var vb:VBox = new VBox();  
            vb.horizontalScrollPolicy = "off";  
            vb.verticalScrollPolicy = "off";
            vb.setStyle("verticalGap",0);
            vb.setStyle("horizontalGap",0);

	  		for(var i:int=0;i<_notifcations.length && i<_maxMessages;i++)
		  	{	
  	            var vboxMessage:VBox = new VBox();
  	            vboxMessage.width=width;
  	            vboxMessage.mouseChildren=false;
  	            vboxMessage.buttonMode=true;
  	            vboxMessage.useHandCursor=true;
  	            vboxMessage.horizontalScrollPolicy = "off";  
            	vboxMessage.verticalScrollPolicy = "off";
            	vboxMessage.setStyle("verticalGap", 0);
            	vboxMessage.setStyle("horizontalGap", 0);
            	vboxMessage.setStyle("paddingLeft", _padding);
        		vboxMessage.setStyle("paddingRight" ,_padding); 
        		vboxMessage.setStyle("paddingTop", _padding);
        		vboxMessage.setStyle("paddingBottom" ,_padding);  
  	            vboxMessage.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void{ e.target.setStyle("backgroundColor","#444444"); });
  	            vboxMessage.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void{ e.target.setStyle("backgroundColor","#313131"); });
        		vboxMessage.addEventListener(MouseEvent.CLICK, goToForumsPage);
		  		
	       		var lblForumName:Label = new Label();
	       		lblForumName.name = "lblMessageTitle";
	        	lblForumName.text = "cix:" + _notifcations[i].Forum + "/" + _notifcations[i].Topic + ":" + _notifcations[i].MessageID;
	 			lblForumName.setStyle("fontSize", 12);
	 			
	 			var lblBody:Text = new Text();  	            
	 			if(_notifcations[i].Body.length > 90)
	        		lblBody.text = _notifcations[i].Body.substr(0, 87) + "...";
        		else
        			lblBody.text = _notifcations[i].Body;
	 			lblBody.setStyle("fontSize", 12);
	 			
	 			lblBody.percentWidth = 100;
	 			lblBody.height = 50;
	 			
	 			var hb:HBox = new HBox();
	            hb.horizontalScrollPolicy = "off";  
	            hb.verticalScrollPolicy = "off";
	        	hb.setStyle("verticalAlign", "middle");
	 
	 			var authorImg:Image = new Image();
				authorImg.source="/img/icon_profile10.png";
	 
				var lblAuthor:Label = new Label();  
	        	lblAuthor.text = _notifcations[i].Author;
	 			lblAuthor.setStyle("fontSize", 10);
	 
	     		var hr:HRule = new HRule();
	 			hr.width=width;
	 			hr.setStyle("strokeColor", "#222222");
	 			hr.setStyle("shadowColor", "#444444");
	 			
	 			hb.addChild(authorImg);
	 			hb.addChild(lblAuthor);
	 			
	 			vboxMessage.addChild(lblForumName);
	 			vboxMessage.addChild(lblBody);
	 			vboxMessage.addChild(hb);
	 			
	        	vb.addChild(vboxMessage);
	        	vb.addChild(hr);  
		  	}
		  	if (_notifcations.length > _maxMessages) {
		  	
		  		var vboxMessage2:VBox = new VBox();
  	            vboxMessage2.width=width;
  	            vboxMessage2.horizontalScrollPolicy = "off";  
            	vboxMessage2.verticalScrollPolicy = "off";
            	vboxMessage2.setStyle("verticalGap", 0);
            	vboxMessage2.setStyle("horizontalGap", 0);
            	vboxMessage2.setStyle("paddingLeft", _padding);
        		vboxMessage2.setStyle("paddingRight" ,_padding); 
        		vboxMessage2.setStyle("paddingTop", _padding);
        		vboxMessage2.setStyle("paddingBottom" ,_padding);  
  	            		  		
	 			var lblBody2:Text = new Text();  	            
        		lblBody2.text = "+ " + (_notifcations.length - maxMessages).toString() + "others.";
	 			lblBody2.setStyle("fontSize", 12);
	 			lblBody2.percentWidth = 100;
	 			lblBody2.height = 106;
	 			
	 			var hb2:HBox = new HBox();
	            hb2.horizontalScrollPolicy = "off";  
	            hb2.verticalScrollPolicy = "off";
	        	hb2.setStyle("verticalAlign", "middle");
	        	
	     		var hr2:HRule = new HRule();
	 			hr2.width=width;
	 			hr2.setStyle("strokeColor", "#222222");
	 			hr2.setStyle("shadowColor", "#444444");
	 			
	 			vboxMessage2.addChild(lblBody);
	 			vboxMessage2.addChild(hb);
	 			
	        	vb.addChild(vboxMessage2);
	        	vb.addChild(hr2);  
		  	}
		  	
		  	this.addChild(vb);
			this.open();
        }  
  		
  		/**
  		 * Generate a CIX Forums url from a cixLink (e.g. cix:Forum/Topic:messageID) that is in the title of the clicked VBox
  		 **/
  		private function goToForumsPage(e:MouseEvent):void {
  			var cixLink:String = e.target.getChildByName("lblMessageTitle").text;
  			var forum:String = cixLink.substring(4, cixLink.indexOf("/", 0));
  			var topic:String = cixLink.substring(cixLink.indexOf("/", 0) + 1, cixLink.indexOf(":", 4));
  			var messageID:String = cixLink.substring(cixLink.indexOf(":", 4) + 1, cixLink.length);
  			var cixForumsURL:String = "http://forums.cixonline.com/secure/thread.aspx?forum=" + forum + "&topic=" + topic + "&msg=" + messageID + "&nu=0";
  			navigateToURL(new URLRequest(cixForumsURL));
  		}
  
        private function showTimerHandler(event:TimerEvent):void
        {  
            _delayTimer = new Timer(_delayTime * 1000, 0);  
            _delayTimer.addEventListener("timer", delayTimerHandler);  
            _delayTimer.start();           
        }  
  
        private function delayTimerHandler(event:TimerEvent):void
        {  
            _showTimer.stop();   
            _delayTimer.stop();
            this.close();    
        }
    }  
}