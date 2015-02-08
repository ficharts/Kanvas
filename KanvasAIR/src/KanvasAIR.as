package
{
	import com.kvs.ui.button.IconBtn;
	
	import commands.ChangeBgImgAIR;
	import commands.Command;
	import commands.DelBgSoundCommand;
	import commands.DelImageFromAIRCMD;
	import commands.InsertBgSoundCommand;
	import commands.InsertIMGFromAIR;
	import commands.InsertVideoCommand;
	
	import control.InteractEvent;
	
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
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.dns.AAAARecord;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import modules.pages.PageManager;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import util.textFlow.FlowTextManager;
	
	import view.MediatorNames;
	import view.themePanel.ThemePanelMediator;
	import view.toolBar.ToolBar;
	
	
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
			
			CoreFacade.instance.registerCommand(Command.INSERT_VIDEO, InsertVideoCommand);
			CoreFacade.instance.registerCommand(Command.INSERT_BG_MUSIC, InsertBgSoundCommand);
			CoreFacade.instance.registerCommand(Command.DEL_BG_MUSIC, DelBgSoundCommand);
			
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
			
			CoreFacade.instance.registerMediator(new ThemePanelMediator(MediatorNames.THEME_PANEL, themePanel));
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
			saveBtn.iconW = saveBtn.iconH = ToolBar.BTN_SIZE;
			saveBtn.w = saveBtn.h = ToolBar.BTN_SIZE;
			saveBtn.setIcons("save_up", "save_over", "save_down");
			saveBtn.tips = '保存';
			saveBtn.addEventListener(MouseEvent.MOUSE_DOWN, saveHandler);
			
			img_save_up;
			img_save_over;
			img_save_down;
			exportImgBtn.iconW = exportImgBtn.iconH = ToolBar.BTN_SIZE;
			exportImgBtn.w = exportImgBtn.h = ToolBar.BTN_SIZE;
			exportImgBtn.setIcons("img_save_up", "img_save_over", "img_save_down");
			exportImgBtn.tips = "存为长图片";
			exportImgBtn.addEventListener(MouseEvent.MOUSE_DOWN, exportImgHandler);
			
			//
			var btns:Vector.<IconBtn> = new Vector.<IconBtn>;
			btns.push(saveBtn)//, exportImgBtn);
			toolBar.addCustomButtons(btns);
			
			kvsCore.addEventListener(KVSEvent.DATA_CHANGED, dataChanged);
			
			templatePanel.initTemplate(XML(ByteArray(new ConfigXML).toString()));
			templatePanel.visible = false;
		}
		
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
			_save();
		}
		
		/**
		 * 文件保存成功后触发
		 */		
		public function saved():void
		{
			if (saveTimmer == null)
			{
				saveTimmer = new Timer(60000);//1分钟自动保存一次
				saveTimmer.addEventListener(TimerEvent.TIMER, saveFromTimmer);
				saveTimmer.start();
			}
			else
			{
				//saveTimmer.reset();
			}
		}
		
		/**
		 */		
		private function saveFromTimmer(evt:TimerEvent):void
		{
			_save();
		}
		
		/**
		 */		
		private function _save():void
		{
			if(!saveBtn.selected)
			{
				airAPI.saveFile();
				saveBtn.selected = true;
			}
		}
		
		/**
		 * 触发自动保存 
		 */		
		private var saveTimmer:Timer;
		
		/**
		 */		
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
			
			addEventListener(Event.COPY, copyHandler);
			addEventListener(Event.PASTE, pastHandler);
		}
		
		/**
		 */		
		private function copyHandler(evt:Event):void
		{
			
		}
		
		/**
		 */		
		private function pastHandler(evt:Event):void
		{
			var filesArray:Array = Clipboard.generalClipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			
			if (filesArray)
				openPastOrDropFile(filesArray);
			
			Clipboard.generalClipboard.clear();
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
			openPastOrDropFile(filesArray);
		}
		
		/**
		 */		
		private function openPastOrDropFile(filesArray:Array):void
		{
			if (filesArray.length)
			{
				var extension:String
				for each (var f:File in filesArray)
				{
					extension = f.extension.toLowerCase();
					if (extension == "kvs" || extension == "pez")
					{
						if (filesArray.length == 1)
							airAPI.openFile(f);
					}
					else if (extension == "jpg" || extension == "png" || extension == "swf")
					{
						if (this.templatePanel.isOpen == false || airAPI.file)
							CoreFacade.sendNotification(Command.INSERT_IMAGE, f);
					}
					else if (extension == "flv" || extension == "mp4")
					{
						if (this.templatePanel.isOpen == false || airAPI.file)
							CoreFacade.sendNotification(Command.INSERT_VIDEO, f);
					}
					else
					{
						
					}
				}
				
			}
		}
		
		/**
		 */		
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
			//NativeApplication.nativeApplication.activeWindow.maximize();
			
			if (event.arguments.length > 0) 
			{ 
				var file:File = new File(event.arguments[0]); 
				var extension:String = file.extension.toLowerCase();
				
				//先赋值，防止双击文件无法直接开启
				airAPI.file = file;
				
				if (airAPI.file)
					airAPI.openFile(airAPI.file);
			}
			else// 正常打开应用，没有通过双击文件方式 
			{
				// 正在编辑文件时，窗口切换也会导致程序运行到这里
				if (ifOpend == false)
					templatePanel.visible = true;
			}
			
			ifOpend = true;
		} 
		
		private var ifOpend:Boolean = false;
		
		/**
		 */		
		private var updater:AIRUpdater;
		
		[Embed(source="templates/config.xml", mimeType="application/octet-stream")]
		public var ConfigXML:Class;
		
		public static const AIR_CLIENT_URL:String = "http://www.kanvas.cn/client/Kanvas.air";
	}
}