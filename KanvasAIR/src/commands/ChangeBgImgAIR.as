package commands
{
	import com.kvs.utils.ImageExtractor;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgInsertor;
	import util.img.ImgLib;
	import util.undoRedo.UndoRedoMannager;

	/**
	 */	
	public class ChangeBgImgAIR extends ChangeBgImgBase
	{
		public function ChangeBgImgAIR()
		{
			super();
		}
		
		/**
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			if(CoreFacade.coreProxy.bgVO.imgURL)
				sendNotification(Command.DELETE_BG_IMG);
			
			try {
				handler = notification.getBody() as Function;
			}
			catch(e:Error) { }
			
			file.browse([new FileFilter("Images", "*.jpg;*.png")]);
			file.addEventListener(Event.SELECT, fileSelected);
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			var filestream:FileStream = new FileStream;
			filestream.open(file, FileMode.READ);
			
			var bytes:ByteArray = new ByteArray;
			filestream.readBytes(bytes, 0, file.size);
			
			imgExtractor = new ImageExtractor(bytes);
			imgExtractor.addEventListener(Event.COMPLETE, imgLoaded);
		}
		
		private function imgLoaded(evt:Event):void
		{
			if (handler != null)
			{
				handler();
				handler = null;
			}
			var bmd:BitmapData = imgExtractor.bitmapData;
			var imgID:uint = ImgLib.imgID;
			
			oldImgObj = {};
			oldImgObj.imgID   = CoreFacade.coreProxy.bgVO.imgID;
			oldImgObj.imgData = CoreFacade.coreProxy.bgVO.imgData;
			oldImgObj.imgURL  = CoreFacade.coreProxy.bgVO.imgURL;
			
			newImgObj = {};
			newImgObj.imgID   = imgID;
			newImgObj.imgData = imgExtractor.bitmapData;
			//newImgObj.imgURL  = evt.imgURL;
			
			setBgImg(newImgObj, true);
			
			ImgLib.register(imgID.toString(), imgExtractor.bytes);
			
			UndoRedoMannager.register(this);
		}
		
		private var handler:Function;
		
		
		/**
		 */		
		private var file:File = new File;
		
		private var imgExtractor:ImageExtractor;
		
		private var imgID:uint;
		
		private var v:Vector.<PageVO>;
	}
}