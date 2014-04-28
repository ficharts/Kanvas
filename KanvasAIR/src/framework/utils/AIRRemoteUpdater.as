/*
 * Copyright (C) 2007 Claus Wahlers
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

/*
 * Contributors:
 *    Borek Bernard, http://www.borber.com/
 *    - namespace dependencies removed
 */

package framework.utils
{
	import flash.desktop.NativeApplication;
	import flash.desktop.Updater;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.*;
	import flash.utils.*;
	
	import framework.fzip.*;
	
	[Event(name="versionCheck", type="framework.utils.AIRRemoteUpdaterEvent")]
	
	[Event(name="update", type="framework.utils.AIRRemoteUpdaterEvent")]
	
	[Event(name="runtimeError", type="framework.utils.AIRRemoteUpdaterEvent")]
	
	public class AIRRemoteUpdater extends EventDispatcher
	{
		protected static const pathAppXml:String = "META-INF/AIR/application.xml";
		
		protected var _localVersion:String = "";
		protected var _remoteVersion:String = "";
		protected var _request:URLRequest;
		
		protected var _type:String;
		
		public function AIRRemoteUpdater() { }
		
		public function update(request:URLRequest, type:String = "update"):void {
			_request = request;
			_type = type;
			if(_type == "force") {
				forceUpdate();
			} else {
				_localVersion = getLocalVersion();
				var fzip:FZip = new FZip();
				fzip.addEventListener(FZipEvent.FILE_LOADED, zipFileLoadedHandler);
				fzip.addEventListener(IOErrorEvent.IO_ERROR, defaultHandler);
				fzip.addEventListener(SecurityErrorEvent.SECURITY_ERROR, defaultHandler);
				fzip.addEventListener(FZipErrorEvent.PARSE_ERROR, parseError);
				fzip.load(request);
			}
		}

		public function get localVersion():String {
			return _localVersion;
		}
		
		public function get remoteVersion():String {
			return _remoteVersion;
		}
		public function get updatable():Boolean
		{
			return compareVersions()>0;
		}
		
		protected function parseError(e:FZipErrorEvent):void
		{
			dispatchEvent(new AIRRemoteUpdaterEvent(AIRRemoteUpdaterEvent.RUNTIME_ERROR));
		}
		
		protected function zipFileLoadedHandler(e:FZipEvent):void {
			if(e.file.filename == pathAppXml) {
				FZip(e.target).close();
				var content:String = e.file.getContentAsString();
				var contentXML:XML = new XML(content);
				_remoteVersion = getVersion(contentXML);
				dispatchEvent(new AIRRemoteUpdaterEvent(AIRRemoteUpdaterEvent.VERSION_CHECK))
				if (updatable && _type == "update")
					forceUpdate();
			}
		}
		
		protected function forceUpdate():void {
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, fileCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, defaultHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, defaultHandler);
			loader.addEventListener(Event.OPEN, defaultHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, defaultHandler);
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, defaultHandler);
			loader.load(_request);
		}

		protected function fileCompleteHandler(e:Event):void {
			var file:File = File.createTempFile();
			var stream:FileStream = new FileStream();
			var data:ByteArray = URLLoader(e.target).data as ByteArray;
			stream.open(file, FileMode.WRITE);
			stream.writeBytes(data);
			stream.close();
			if(dispatchEvent(new AIRRemoteUpdaterEvent(AIRRemoteUpdaterEvent.UPDATE, file))) {
				var updater:Updater = new Updater();
				try{
					updater.update(file, _remoteVersion);
				}catch(e:Error)
				{
					dispatchEvent(new AIRRemoteUpdaterEvent(AIRRemoteUpdaterEvent.RUNTIME_ERROR));
				}
			}
		}

		protected function defaultHandler(e:Event):void {
			dispatchEvent(e.clone());
		}
		
		protected function getVersion(appDescriptor:XML):String {
			var ns:Namespace = appDescriptor.namespace();
			if (NativeApplication.nativeApplication.runtimeVersion>"2.6") {
				return appDescriptor.ns::versionNumber[0];
			} else {
				return appDescriptor.ns::version[0];
			}
		}

		protected function getLocalVersion():String {
			return getVersion(NativeApplication.nativeApplication.applicationDescriptor);
		}
		
		protected function compareVersions():int {
			if(_remoteVersion > _localVersion) {
				return 1;
			} else if(_remoteVersion < _localVersion) {
				return -1;
			} else {
				return 0;
			}
		}
	}
}
