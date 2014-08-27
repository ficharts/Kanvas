package commands 
{
	import com.kvs.utils.extractor.ExtractorBase;
	import com.kvs.utils.extractor.ImageExtractor;
	import com.kvs.utils.extractor.SWFExtractor;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgLib;
	
	import view.ui.Bubble;

	/**
	 * 
	 * @author wallenMac
	 * 
	 * 桌面版本下的插入图片
	 * 
	 */	
	public class InsertIMGFromAIR extends InsertImgCMDBase
	{
		public function InsertIMGFromAIR()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			file = notification.getBody() as File;
			
			if (file)
			{
				start();
			}
			else
			{
				file = new File;
				file.browse([new FileFilter("Images", "*.jpg;*.png;*.swf")]);
				file.addEventListener(Event.SELECT, fileSelected);
			}
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			start();
		}
		
		/**
		 */		
		private function start():void
		{
			var filestream:FileStream = new FileStream;
			filestream.open(file, FileMode.READ);
			
			var bytes:ByteArray = new ByteArray;
			filestream.readBytes(bytes, 0, file.size);
			
			if (file.extension == "swf")
				imgExtractor = new SWFExtractor();
			else
				imgExtractor = new ImageExtractor();
			
			imgExtractor.addEventListener(Event.COMPLETE, imgLoaded);
			
			try
			{
				imgExtractor.init(bytes);
			}
			catch (e:Error)
			{
				Bubble.show(e.message);
			}
		}
		
		/**
		 */		
		private function imgLoaded(evt:Event):void
		{
			var imgID:uint = ImgLib.imgID;
			
			createImg(imgExtractor.view, imgID, imgExtractor.fileBytes);
			ImgLib.register(imgID.toString(), imgExtractor.fileBytes);
				
			element.toNomalState();
		}
		
		/**
		 */		
		private var imgExtractor:ExtractorBase;
		
		/**
		 */		
		private var file:File;
		
	}
}