package
{
	import com.coltware.airxzip.ZipEntry;
	import com.coltware.airxzip.ZipFileReader;
	import com.coltware.airxzip.ZipFileWriter;
	import com.kvs.utils.PerformaceTest;
	
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import model.ConfigInitor;
	import model.CoreFacade;
	
	import util.img.ImgInsertEvent;
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;

	/**
	 * air客户端的api
	 */	
	public class APIForAIR extends KanvasAPI
	{
		public function APIForAIR(core:CoreApp)
		{
			super(core);
		}
		
		/**
		 */		
		private function imgLoaded(evt:ImgInsertEvent):void
		{
			
		}
		
		/**
		 */		
		private function imgLoadError(e:ImgInsertEvent):void
		{
			
		}
		
		/**
		 * 当前文件
		 */		
		public var file:File;
		
		/**
		 * 打开文件 
		 */		
		public function openFile(newfile:File = null):void
		{
			if (newfile)
			{
				this.file = newfile;
				readFile();
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, fileSelected);
				file.browse([new FileFilter("kvs", "*.kvs")]);
			}
		}
		
		/**
		 */		
		private function fileSelected(evt:Event):void
		{
			readFile();
			file.removeEventListener(Event.SELECT, fileSelected);
		}
		
		/**
		 */		
		private function readFile():void
		{
			var reader:ZipFileReader = new ZipFileReader();
			reader.open(file);
			
			PerformaceTest.ifRun = true;
			PerformaceTest.start();
			
			var list:Array = reader.getEntries();
			var xml:String;
			var imgID:String;
			var imgIDsInKvs:Array = new Array;
				
			var imgData:ByteArray;
			
			for each(var entry:ZipEntry in list)
			{
				if(entry.getFilename() == "kvs.xml")
				{
					xml = reader.unzip(entry).toString();
				}
				else
				{
					imgData = reader.unzip(entry);
					imgID = entry.getFilename().split('.')[0].toString();
					
					if (uint(imgID) != 0)
					{
						ImgLib.register(imgID, imgData);
						imgIDsInKvs.push(imgID);
					}
				}
			}
			
			this.setXMLData(xml);
			reader.close();
			
			//这里需要清理冗余的图片数据
			var imgIDsInXML:Array = [];
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElement)
					imgIDsInXML.push((element as ImgElement).imgVO.imgID);
			}
			
			//如果数据中的图片id不存在于xml中，则说明此图片是多余图片，删除
			for each (var id:uint in imgIDsInKvs)
			{
				if (imgIDsInXML.indexOf(id) == - 1)
					ImgLib.unRegister(id);
			}
			
			PerformaceTest.end();
		}
		
		/**
		 * 保存文件 
		 */		
		public function saveFile():void
		{
			if (file)
			{
				writeFile();
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, selectFileForSave);
				file.browseForSave("保存kanvas文件");
			}
		}
		
		/**
		 */		
		private function selectFileForSave(evt:Event):void
		{
			file.removeEventListener(Event.SELECT, selectFileForSave);
				
			file = new File(file.nativePath + ".kvs")
			writeFile();
		}
		
		/**
		 */		
		private function writeFile():void
		{
			PerformaceTest.start("save");
			
			var writer:ZipFileWriter = new ZipFileWriter();
			
			writer.openAsync(this.file);
			
			// file info
			var fileData:ByteArray = new ByteArray();
			fileData.writeUTFBytes(this.getXMLData());
			writer.addBytes(fileData,"kvs.xml");
			//fileData.clear();
			
			//图片相关
			var imgIDs:Array = ImgLib.imgKeys;
			var imgDataBytes:ByteArray;
			
			//缩略图
			var bmd:BitmapData = core.thumbManager.getShotCut(ConfigInitor.THUMB_WIDTH, ConfigInitor.THUMB_HEIGHT);
			if (bmd)
			{
				imgDataBytes = bmd.encode(bmd.rect, new PNGEncoderOptions);
				writer.addBytes(imgDataBytes,"preview.png");
			}
			
			// 添加图片资源数据
			var imgBytes:ByteArray;
			for each (var imgID:uint in imgIDs)
			{
				//imgDataBytes.clear();
				imgDataBytes = new ByteArray();
				imgBytes = ImgLib.getData(imgID);
				imgBytes.position = 0;
				imgDataBytes.writeBytes(imgBytes, 0, imgBytes.bytesAvailable);
				imgDataBytes.position = 0;
				
				writer.addBytes(imgDataBytes,imgID.toString() + '.png');
			}
			
			writer.close();
			PerformaceTest.end("save");
			
			return;
			
			var pageData:ByteArray = core.thumbManager.getPageBytes(960, 720);
			if (pageData)
			{
				var vector:Vector.<ByteArray> = core.thumbManager.resolvePageData(pageData);
				var flag:int = 1;
				for each (var bytes:ByteArray in vector)
				{
					writer.addBytes(bytes, "pages/" + (flag++) + ".jpg");
				}
			}
			
		}
		
	}
}