package
{
	import com.kvs.ui.button.IconBtn;
	
	import commands.ChangeBgImgAIR;
	import commands.DelImageFromAIRCMD;
	import commands.InsertIMGFromAIR;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	import model.CoreProxy;
	import model.vo.PageVO;
	
	import modules.PreziDataImporter;
	import modules.pages.PageManager;
	
	import util.textFlow.FlowTextManager;
	
	
	/**
	 * 
	 */	
	public class KanvasAIR extends Kanvas
	{
		public function KanvasAIR()
		{
			super();
			
			initKanvasAIR();
		}
		
		private function initKanvasAIR():void
		{
			CoreApp.isAIR = true;
			CoreFacade.inserImgCommad = InsertIMGFromAIR;
			CoreFacade.insertBgCommand = ChangeBgImgAIR;
			CoreFacade.delImgCommad = DelImageFromAIRCMD;
			
			FlowTextManager.ifUseEmbedFont = true;
			kvsCore.addEventListener(KVSEvent.SAVE, saveHandler);
			//kvsCore.addEventListener(KVSEvent.THEME_CHANGED, themeChanged);
		}
		
		/**
		 * 此函数用来辅助批量生成样式截图
		 */		
		private function themeChanged(evt:KVSEvent):void
		{
			var themeID:String = evt.themeID;
			
			var pageManager:PageManager = CoreFacade.coreMediator.pageManager;
			
			if (pageManager.length)
			{
				var page:PageVO = pageManager.getPageAt(0);
				var pageBMD:BitmapData = pageManager.getThumbByPageVO(page, 180, 130, true);
				var jpgEncodeOptions:JPEGEncoderOptions = new JPEGEncoderOptions;
				jpgEncodeOptions.quality = 100;
				var dat:ByteArray  = pageBMD.encode(pageBMD.rect, jpgEncodeOptions);
				
				var file:File = new File(File.desktopDirectory.nativePath+ "/" + themeID);
				var files:FileStream = new FileStream();
				files.open(file, FileMode.WRITE);
				files.writeBytes(dat, 0, dat.bytesAvailable);
				files.close();
			}
				
		}
		
		/**
		 */		
		override protected function init():void
		{
			super.init();
			registFileRef();
			
			FlowTextManager.loadFont("FontLib.swf");
			addChild(updater = new AIRUpdater);
			updater.update(AIR_CLIENT_URL, "check");
		}
		
		/**
		 */		
		override protected function kvsReadyHandler(evt:KVSEvent):void 
		{
			super.kvsReadyHandler(evt);
			
			this.api = new APIForAIR(kvsCore, this);
			
			save_up;
			save_over;
			save_down;
			saveBtn.iconW = saveBtn.iconH = 30;
			saveBtn.w = saveBtn.h = 30;
			saveBtn.setIcons("save_up", "save_over", "save_down");
			saveBtn.tips = '保存';
			saveBtn.addEventListener(MouseEvent.MOUSE_DOWN, saveHandler);
			
			exportImgBtn.iconW = exportImgBtn.iconH = 30;
			exportImgBtn.w = exportImgBtn.h = 30;
			exportImgBtn.setIcons("save_up", "save_over", "save_down");
			exportImgBtn.tips = "导出微博图片";
			exportImgBtn.addEventListener(MouseEvent.MOUSE_DOWN, exportImgHandler);
			//
			var btns:Vector.<IconBtn> = new Vector.<IconBtn>;
			btns.push(saveBtn, exportImgBtn);
			toolBar.addCustomButtons(btns);
			
			kvsCore.addEventListener(KVSEvent.DATA_CHANGED, dataChanged);
			
			templatePanel.initTemplate(templates);
		}
		
		/**
		 */		
		private var templates:XML = 
			<templates>
				<template id='13' icon='templates/images/template13.png' name='模板1' path='templates/files/template13.kvs'/>
				<template id='1' icon='templates/images/template1.png' name='模板1' path='templates/files/template1.kvs'/>
				<template id='2' icon='templates/images/template2.png' name='模板2' path='templates/files/template2.kvs'/>
				<template id='3' icon='templates/images/template3.png' name='模板3' path='templates/files/template3.kvs'/>
				<template id='4' icon='templates/images/template4.png' name='模板4' path='templates/files/template4.kvs'/>
				<template id='5' icon='templates/images/template5.png' name='模板5' path='templates/files/template5.kvs'/>
				<template id='6' icon='templates/images/template6.png' name='模板6' path='templates/files/template6.kvs'/>
				<template id='7' icon='templates/images/template7.png' name='模板7' path='templates/files/template7.kvs'/>
				<template id='8' icon='templates/images/template8.png' name='模板8' path='templates/files/template8.kvs'/>
				<template id='9' icon='templates/images/template9.png' name='模板9' path='templates/files/template9.kvs'/>
				<template id='10' icon='templates/images/template10.png' name='模板10' path='templates/files/template10.kvs'/>
				<template id='11' icon='templates/images/template11.png' name='模板11' path='templates/files/template11.kvs'/>
				<template id='12' icon='templates/images/template12.png' name='模板12' path='templates/files/template12.kvs'/>
			</templates>;
		
		
		
		/**
		 */		
		private function dataChanged(evt:KVSEvent):void
		{
			saveBtn.selected = false;
		}
		
		/**
		 * 鼠标按下与快捷键点击共同作用与此方法，用来保存文件
		 */		
		private function saveHandler(evt:Event):void
		{
			if(!saveBtn.selected)
			{
				saveBtn.selected = true;
				airAPI.saveFile();
			}
		}
		
		private function exportImgHandler(evt:Event):void
		{
			airAPI.exportImg();
		}
		
		/**
		 * 暂存按钮 
		 */		
		internal var saveBtn:IconBtn = new IconBtn;
		
		internal var exportImgBtn:IconBtn = new IconBtn;
		
		/**
		 */		
		private function get airAPI():APIForAIR
		{
			return api as APIForAIR;
		}
		
		
		
		
		/*********************************************
		 * 
		 * 
		 * 
		 * 
		 * 拖拽，双击方式开启文件
		 * 
		 * 
		 * 
		 * 
		 * 
		 * ********************************************/
		
		/**
		 */		
		private function registFileRef():void
		{
			addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
			addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
			
			if(!NativeApplication.nativeApplication.isSetAsDefaultApplication("kvs")) 
				NativeApplication.nativeApplication.setAsDefaultApplication("kvs");
			
			if(!NativeApplication.nativeApplication.isSetAsDefaultApplication("pez")) 
				NativeApplication.nativeApplication.setAsDefaultApplication("pez");
		}
		
		/**
		 */		
		private function onDragIn(e:NativeDragEvent):void
		{
			var filesInClip:Clipboard = e.clipboard;
			if (filesInClip.hasFormat(ClipboardFormats.FILE_LIST_FORMAT))
			{
				NativeDragManager.acceptDragDrop(this);
				NativeDragManager.dropAction = NativeDragActions.MOVE;
			}
		}
		
		/**
		 */		
		private function onDragDrop(e:NativeDragEvent):void
		{
			var filesArray:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (filesArray.length)
			{
				var f:File = filesArray[0];
				var extension:String = f.extension.toLowerCase();
				if (extension == "kvs" || extension == "pez")
				{
					airAPI.openFile(f);
				}
				else if (extension == "jpg" || extension == "png")
				{
					
				}
				else
				{
					
				}
			}
		}
		
		override protected function stageResizeHandler(evt:Event):void
		{
			super.stageResizeHandler(evt);
			updater.render();
		}
		
		/**
		 * 双击方式开启文件
		 */		
		private function onInvoke( event:InvokeEvent ):void 
		{ 
			if (NativeApplication.nativeApplication.activeWindow == null)
				return;
				
			//先窗口最大化
			NativeApplication.nativeApplication.activeWindow.maximize();
			
			if (event.arguments.length > 0) 
			{ 
				var file:File = new File(event.arguments[0]); 
				var extension:String = file.extension.toLowerCase();
				
				if (airAPI.file)
				{
					airAPI.openFile(file);
				}
				else
				{
					airAPI.file = file;
					kvsCore.addEventListener(Event.RESIZE, kvsResizeHandler);
				}
			} 
		} 
		
		/**
		 */		
		private function kvsResizeHandler(evt:Event):void
		{
			if (airAPI.file)
			{
				airAPI.openFile(airAPI.file);
				kvsCore.removeEventListener(Event.RESIZE, kvsResizeHandler);
			}
		}
		
		private var updater:AIRUpdater;
		
		
		
		public static const AIR_CLIENT_URL:String = "http://www.kanvas.cn/client/Kanvas.air";
	}
}