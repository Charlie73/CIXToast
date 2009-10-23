package com.cix
{
	import OAuth.OAuthToken;
	
	import flash.filesystem.*;
	
	import mx.controls.Alert;
	
	public class SaveData
	{
		private const _appDataFileName:String = "appSettings";
		
		private var _prefsFile:File;						// The preferences prefsFile
		private var _appSettingsXML:XML; 					// The XML data
		private var _stream:FileStream;						// The FileStream object used to read and write prefsFile data.
		private var _outputString:String;					// Used to create a string that is saved to XML 
		
		public function SaveData() {
  			_prefsFile = File.applicationStorageDirectory;
			_prefsFile = _prefsFile.resolvePath(_appDataFileName +".xml"); 
      		_stream = new FileStream();
          	// If the file does not exsist, create it	
			if (!_prefsFile.exists) {
				// create base XML data	
				_appSettingsXML = <AppSettings/>;
				_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
				_outputString += _appSettingsXML.toXMLString();
				_outputString = _outputString.replace(/\n/g, File.lineEnding);
				_stream.open(_prefsFile, FileMode.WRITE);
				_stream.writeUTFBytes(_outputString);
				_stream.close();
			}		
		}
		
		public function CIXAccessTokenGet():OAuthToken {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();
			if (_appSettingsXML.CIXSettings.AccessToken != undefined)
				return new OAuthToken(_appSettingsXML.CIXSettings.AccessToken.Key, _appSettingsXML.CIXSettings.AccessToken.Secret);
			else
				return null;
		}
		
		public function CIXAccessTokenSave(accessToken:OAuthToken):void {       
			_stream.open(_prefsFile, FileMode.READ);
	    	_appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();
			  		
			// if it already exists, overwrite it  		
			if(_appSettingsXML.CIXSettings.AccessToken != undefined) {
				_appSettingsXML.CIXSettings.AccessToken.Key = accessToken.key;
				_appSettingsXML.CIXSettings.AccessToken.Secret = accessToken.secret;		
				_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
				_outputString += _appSettingsXML.toXMLString();
				_outputString = _outputString.replace(/\n/g, File.lineEnding);
				_stream.open(_prefsFile, FileMode.WRITE);
				_stream.writeUTFBytes(_outputString);
				_stream.close();
			}
			else {// create a new accessToken
				var accessTokenXML:XML;
				accessTokenXML = <AccessToken/>;
				accessTokenXML.Key = accessToken.key;
				accessTokenXML.Secret = accessToken.secret;
				_appSettingsXML.CIXSettings.AccessToken = accessTokenXML;
				_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
				_outputString += _appSettingsXML.toXMLString();
				_outputString = _outputString.replace(/\n/g, File.lineEnding);
				_stream.open(_prefsFile, FileMode.WRITE);
				_stream.writeUTFBytes(_outputString);
				_stream.close();
			}
		}
		
		public function clearAllData():void {
			_prefsFile.deleteFile();
		}
		
		public function windowPositionSave(sX:int, sY:int, pX:int, pY:int):void {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();
			
			if (_appSettingsXML.Window.length() > 0)	
				delete _appSettingsXML.Window;	
			
			var window:XML = <Window/>;
			window.appendChild(<Position><X>{pX}</X><Y>{pY}</Y></Position>);
			window.appendChild(<Size><X>{sX}</X><Y>{sY}</Y></Size>);
			_appSettingsXML.appendChild(window);
			_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
			_outputString += _appSettingsXML.toXMLString();
			_outputString = _outputString.replace(/\n/g, File.lineEnding);
			_stream.open(_prefsFile, FileMode.WRITE);
			_stream.writeUTFBytes(_outputString);
			_stream.close();		
		}
		
		public function windowPositionGet():XMLList {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();

			if(_appSettingsXML.Window.length() > 0)
				return _appSettingsXML.Window;
			
			else
				return null;	
		}
		
		public function forumsGet():XMLList {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();

			if (_appSettingsXML.CIXSettings.Forums != undefined)
				return _appSettingsXML.CIXSettings.Forums;
			else
				return null;
		}
		
		public function forumSave(forum:XML):void {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();
						
			// if the alerts node already exists		
			if(_appSettingsXML.CIXSettings.Forums != undefined) {
				// if the forum alert exsists, set the correct @alert value  
				if (_appSettingsXML.CIXSettings.Forums.Forum.(@name == forum.@name).length() > 0)
					_appSettingsXML.CIXSettings.Forums.Forum.(@name == forum.@name).(@alert = forum.@alert);
				else {
					//loop through to find out where to place our xml alphabetically
					var insertWhere:XML;
					for each (var f:XML in _appSettingsXML.CIXSettings.Forums.Forum) {
						if (forum.@name < f.@name.toString()) {
							insertWhere = f;
							break;
						}
					}
					_appSettingsXML.CIXSettings.Forums.insertChildBefore(insertWhere, forum);
				}
			}
			else {// create a new alert node
				var ForumsXML:XML;
				ForumsXML = "<Forums><Forum name=" + forum.@name + " alert=" + forum.@alert + " /><Forums>" as XML;
				_appSettingsXML.CIXSettings.Forums = ForumsXML;
			}
			
			_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
			_outputString += _appSettingsXML.toXMLString();
			_outputString = _outputString.replace(/\n/g, File.lineEnding);
			_stream.open(_prefsFile, FileMode.WRITE);
			_stream.writeUTFBytes(_outputString);
			_stream.close();
		}
		
		public function forumDelete(forum:String):void {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();

			delete _appSettingsXML.CIXSettings.Forums.Forum.(@name==forum)[0];
			
			_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
			_outputString += _appSettingsXML.toXMLString();
			_outputString = _outputString.replace(/\n/g, File.lineEnding);
			_stream.open(_prefsFile, FileMode.WRITE);
			_stream.writeUTFBytes(_outputString);
			_stream.close();
		}
		
		public function forumsSaveAllForum(forums:XML):void {
			_stream.open(_prefsFile, FileMode.READ);
		    _appSettingsXML = XML(_stream.readUTFBytes(_stream.bytesAvailable));
			_stream.close();
			
			// if the alerts node already exists delete it  		
			if(_appSettingsXML.CIXSettings.Forums != undefined) {
				delete _appSettingsXML.CIXSettings.Forums;
			}

			var ForumsXML:XML;
			ForumsXML = <Forums/>;
			_appSettingsXML.CIXSettings.Forums = forums;
			_outputString = '<?xml version="1.0" encoding="utf-8"?>\n';
			_outputString += _appSettingsXML.toXMLString();
			_outputString = _outputString.replace(/\n/g, File.lineEnding);
			_stream.open(_prefsFile, FileMode.WRITE);
			_stream.writeUTFBytes(_outputString);
			_stream.close();
		}
		
	}
}