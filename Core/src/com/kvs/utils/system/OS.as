package com.kvs.utils.system
{
	import com.kvs.utils.ClassUtil;
	
	import flash.display.BitmapData;
	import flash.net.LocalConnection;
	import flash.system.System;

	/**
	 */	
	public class OS
	{
		public function OS()
		{
			
		}
		
		/**
		 * 扩充FP内存, 防止加载图片导致内存不够的崩溃
		 */		
		public static function enlargeMemory():void
		{
			if (memoryIMG == null)
			{
				memoryIMG = new BitmapData(1024, 1024);
				memoryIMG = new BitmapData(2048, 2048);
			}
		}
		
		/**
		 */		
		public static function memoryGc():void
		{
			memoryIMG.dispose();
			memoryIMG = null;
			System.gc();
		}
		
		/**
		 */		
		private static var memoryIMG:BitmapData;
		
		/**
		 * 是否为网页环境
		 */		
		public static function get isWebSystem():Boolean
		{
			checkSystem();
			
			return ifWeb;
		}
		
		/**
		 * 目前移动操作系统不支持此特性，咱用此来判断系统类型；
		 */		
		public static function get isDesktopSystem():Boolean
		{
			checkSystem();
			
			return ifDeskAIR;
		}
		
		/**
		 */		
		public static function get isMobileSystem():Boolean
		{
			checkSystem();
			
			return ifMobile;
		}
		
		/**
		 */		
		private static function checkSystem():void
		{
			if (isChecked == false)
			{
				if (ClassUtil.getObjectByClassPath("flash.desktop.NativeProcess"))
					ifDeskAIR = true;
				else
					ifDeskAIR = false;
				
				if (LocalConnection.isSupported == false)
					ifMobile = true;
				else
					ifMobile = false;
				
				if (ifDeskAIR == false && ifMobile == false)
					ifWeb = true;
				else
					ifWeb = false;
				
				isChecked = true;
			}
		}
		
		/**
		 */		
		private static var isChecked:Boolean = false;
		
		/**
		 * 是否是桌面AIR环境
		 */		
		private static var ifDeskAIR:Boolean = false;
		
		/**
		 * 是否是移动环境
		 */		
		private static var ifMobile:Boolean = false;
		
		/**
		 */		
		private static var ifWeb:Boolean = false;
		
		
		
	}
}