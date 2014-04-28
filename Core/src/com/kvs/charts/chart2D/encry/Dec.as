
package com.kvs.charts.chart2D.encry
{
	import com.kvs.utils.ExternalUtil;
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;
	import com.kvs.utils.XMLConfigKit.style.LabelStyle;
	import com.kvs.ui.label.LabelUI;
	import com.kvs.utils.dec.CCB;
	import com.kvs.utils.dec.ICipher;
	import com.kvs.utils.dec.IPad;
	import com.kvs.utils.dec.IVMode;
	import com.kvs.utils.dec.KP;
	import com.kvs.utils.dec.Made;
	import com.kvs.utils.dec.SEA;
	import com.kvs.utils.dec.VI;
	import com.kvs.utils.graphic.BitmapUtil;
	import com.kvs.utils.system.OS;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	/**
	 * 
	 * 负责解密、License验证、水印显示
	 */	
	public class Dec
	{
		public function Dec()
		{
		}
		
		/**
		 */		
		public function run(shell:CSB):void
		{
			this.shell = shell;
			
			configByte = ByteArray(new Meta);
			licenseByte = ByteArray(new Lc);
			
			var md5:Made = new Made;
			decryConfigFile(md5.fuck(licenseByte));
			
			licenseByte.uncompress();
			configByte.uncompress();
			shell.initStyleTempalte(configByte.toString());
			shell.init();
			
			verify();
		}
		
		/**
		 */		
		private var shell:CSB;
		
		/**
		 * 
		 * trail 为试用版，永远有水印
		 * 
		 * desk 用于AIR客户端，通过mac地址认证
		 * 
		 * app  用于客户端和手机端，根据应用ID来认证
		 * 
		 * 服务器授权分内网与外网，目前仅能依靠人工方式检验license是否被滥用
		 * 
		 */		
		private function verify():void
		{
			var licenseVO:LM = new LM;
			var liXML:XML = XML(licenseByte.toString());
			XMLVOMapper.fuck(liXML, licenseVO);
			XMLVOMapper.fuck(liXML.servers, licenseVO);
			var ifSuccess:Boolean = false;
			
			if (licenseVO.type == LM.TRIAL) // 免费版
			{
				createLicenseInfo('www.ficharts.com');
			}
			else if (licenseVO.type == LM.DESK)// 桌面客户端授权
			{
				if (OS.isDesktopSystem)
				{
					var netInfo:Object = getDefinitionByName("flash.net.NetworkInfo").networkInfo;
					var interfaceVector:Object = netInfo.findInterfaces();
					var mac:String = interfaceVector[0].hardwareAddress;
					
					for each (var url:String in licenseVO.macs)
					{
						if (url == mac)
						{
							ifSuccess = true;
							break;
						}
					}
					
					if (ifSuccess == false)
						createLicenseInfo('www.ficharts.com');
					
				}
				else
				{
					// web 下想用desk的license， 没门
					createLicenseInfo('www.ficharts.com');
				}
			}
			else if (licenseVO.type == LM.APP)// 应用ID授权
			{
				if(OS.isWebSystem)
				{
					// web 下想用App的license， 没门
					createLicenseInfo('www.ficharts.com');
				}
				else
				{
					var appID:String = getDefinitionByName("flash.desktop.NativeApplication").nativeApplication.applicationID;
					for each (var id:String in licenseVO.apps)
					{
						if (appID == id)
						{
							ifSuccess = true;
							break;
						}
					}
					
					if (ifSuccess == false)
						createLicenseInfo('www.ficharts.com');
				}
				
			}
			else // 服务区授权
			{
				var fullURL:String = shell.stage.loaderInfo.url;
				var serverURL:String = getServerName(fullURL);
				
				for each (var domain:String in licenseVO.domains)
				{
					if (serverURL.indexOf(domain) != -1)
					{
						ifSuccess = true;
						break;
					}
				}
				
				if (fullURL.indexOf('localhost') != -1)
					ifSuccess = true;
				
				if (ifSuccess == false)
					createLicenseInfo('www.ficharts.com');
			}
			
			ExternalUtil.call('license', licenseVO);
		}
		
		/**
		 */		
		private function createLicenseInfo(info:String):void
		{
			return;
			
			var label:LabelUI = new LabelUI;
			var labelStyle:LabelStyle = new LabelStyle;
			XMLVOMapper.fuck(labelStyleXML, labelStyle);
			label.style = labelStyle;
			label.text = info;
			label.render();
			
			waterLabel = BitmapUtil.getBitmap(label, true);
			label = null;
			
			shell.stage.addEventListener(Event.RESIZE, stageResized, false, 0, true);
			waterLabel.alpha = 0.5;
			shell.addChild(waterLabel);
			layoutWaterLabel();
		}
		
		/**
		 */		
		private var waterLabel:Bitmap;
		
		/**
		 */		
		private function stageResized(evt:Event):void
		{
			layoutWaterLabel();
		}
		
		/**
		 */		
		private function layoutWaterLabel():void
		{
			waterLabel.width = shell.width * 0.8;
			waterLabel.scaleY = waterLabel.scaleX;
			
			waterLabel.x = (shell.width - waterLabel.width) / 2;
			waterLabel.y = (shell.height - waterLabel.height) / 2 - waterLabel.height;
		}
		
		/**
		 */		
		private var labelStyleXML:XML = <label>
							                <format size='280' color='555555' bold='true' font='微软雅黑'/>
							            </label>
		
		/**
		 * 剔除协议仅保留www.xxx.com或者 xxx.com
		 */		
		protected function getServerName(url:String):String
		{
			var sp:String = getServerNameWithPort(url);
			
			// If IPv6 is in use, start looking after the square bracket.
			var delim:int = sp.indexOf("]");
			delim = (delim > -1)? sp.indexOf(":", delim) : sp.indexOf(":");   
			
			if (delim > 0)
				sp = sp.substring(0, delim);
			return sp;
		}
		
		/**
		 */		
		private function getServerNameWithPort(url:String):String
		{
			// Find first slash; second is +1, start 1 after.
			var start:int = url.indexOf("/") + 2;
			var length:int = url.indexOf("/", start);
			return length == -1 ? url.substring(start) : url.substring(start, length);
		}
		
		/**
		 * 根据license的md5码 解密配置文件;
		 */		
		private function decryConfigFile(licenseMd5:ByteArray):void
		{
			var pad:IPad = new KP;
			var aesKey:SEA = new SEA(licenseMd5);
			var cbcMode:CCB = new CCB(aesKey, pad)
			var mode:ICipher = new VI(cbcMode as IVMode);
			pad.setBlockSize(mode.getBlockSize());
			mode.yy(configByte);
		}
		
		/**
		 */		
		private var configByte:ByteArray;
		
		/**
		 */		
		private var licenseByte:ByteArray;
		
		/**
		 */		
		public var Lc:Class;
		
		/**
		 */		
		public var Meta:Class;
	}
}