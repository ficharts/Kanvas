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
	
	import modules.PreziDataImporter;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	import view.element.imgElement.ImgElementBase;
	import view.ui.Bubble;

	/**
	 * air客户端的api
	 */	
	public class APIForAIR extends KanvasAPI
	{
		public function APIForAIR(core:CoreApp, $kanvasAIR:KanvasAIR)
		{
			super(core);
			
			kanvasAIR = $kanvasAIR;
			
			core.stage.nativeWindow.addEventListener(Event.CLOSING,closing);
		}	
		
		/**
		 */		
		private function closing(evt:Event):void
		{
			if (isSaving)
			{
				evt.preventDefault();
				
				Bubble.show("文档保存中，请稍后关闭...");
			}
		}
		
		override public function openTemplate(id:uint):void
		{
			var path:String = File.applicationDirectory.nativePath + "/templates/template"+id+".kvs";
			openFile(new File(path));
		}
		
		/**
		 * 当前文件
		 */		
		public var file:File;
		
		private var kanvasAIR:KanvasAIR;
		
		/**
		 * 打开文件 
		 */		
		public function openFile(newfile:File = null, extension:String = "kvs"):void
		{
			if (newfile)
			{
				this.file = newfile;
				if (extension == "kvs") readFileKVS();
				else if (extension == "pez") readFilePEZ();
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
			readFileKVS();
			file.removeEventListener(Event.SELECT, fileSelected);
		}
		
		/**
		 */		
		private function readFileKVS():void
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
			
			reader.close();
			PerformaceTest.end("文件解压缩结束");
			
			PerformaceTest.start("解析xml");
			this.setXMLData(xml);
			
			//这里需要清理冗余的图片数据
			var imgIDsInXML:Array = [];
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElementBase)
					imgIDsInXML.push((element as ImgElementBase).imgVO.imgID.toString());
			}
			
			//不能忘记背景图
			if (CoreFacade.coreProxy.bgVO.imgID > 0)
				imgIDsInXML.push(CoreFacade.coreProxy.bgVO.imgID.toString());
			
			//如果数据中的图片id不存在于xml中，则说明此图片是多余图片，删除
			for each (var id:String in imgIDsInKvs)
			{
				if (imgIDsInXML.indexOf(id) == - 1)
					ImgLib.unRegister(uint(id));
			}
			
			PerformaceTest.end("xml解析结束");
		}
		
		private function readFilePEZ():void
		{
			var reader:ZipFileReader = new ZipFileReader();
			reader.open(file);
			
			var list:Array = reader.getEntries();
			var imgIDsInKvs:Array = new Array;
			
			for each(var entry:ZipEntry in list)
			{
				var name:String = entry.getFilename();
				if( name == "prezi/content.xml")
				{
					var xml:String = reader.unzip(entry).toString();
				}
				else if (
					name != "prezi/preview.png" && (
					name.indexOf(".jpg" ) > 0 || 
					name.indexOf(".png" ) > 0 || 
					name.indexOf(".jpe" ) > 0 || 
					name.indexOf(".jpeg") > 0 || 
					name.indexOf(".gif" ) > 0 || 
					name.indexOf(".swf" ) > 0 ))
				{
					var imgData:ByteArray = reader.unzip(entry);
					var imgID:String = (name.split('.')[0].toString()).split("/")[2];
					
					if (uint(imgID) != 0)
					{
						ImgLib.register(imgID, imgData);
						imgIDsInKvs.push(imgID);
					}
				}
			}
			setXMLData(PreziDataImporter.convertData(XML(xml)));
			reader.close();
			
			//这里需要清理冗余的图片数据
			var imgIDsInXML:Array = [];
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElement)
					imgIDsInXML.push((element as ImgElement).imgVO.imgID.toString());
			}
			
			if (CoreFacade.coreProxy.bgVO.imgID > 0)
				imgIDsInXML.push(CoreFacade.coreProxy.bgVO.imgID.toString());
			
			//如果数据中的图片id不存在于xml中，则说明此图片是多余图片，删除
			for each (var id:uint in imgIDsInKvs)
			{
				if (imgIDsInXML.indexOf(id.toString()) == - 1)
					ImgLib.unRegister(id);
			}
			
			PerformaceTest.end();
			file = null;
		}
		
		/**
		 * 保存文件 
		 */		
		public function saveFile():void
		{
			if (file)
			{
				try {
					writeFile();
				}
				catch (e:Error)
				{
					file.addEventListener(Event.SELECT, selectFileForSave);
					file.browseForSave("保存kanvas文件");
				}
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, selectFileForSave);
				file.addEventListener(Event.CANCEL, cancelSelectFile);
				file.browseForSave("保存kanvas文件");
			}
		}
		
		/**
		 * 初次选择文件时可能取消，这时要删除文件，不然下次保存时不知道文件保存到哪里去了
		 */		
		private function cancelSelectFile(evt:Event):void
		{
			kanvasAIR.saveBtn.selected = false;
			file = null;
		}
		
		/**
		 */		
		private function selectFileForSave(evt:Event):void
		{
			file.removeEventListener(Event.SELECT, selectFileForSave);
			
			var s:String = file.nativePath;
			
			file = new File((s.indexOf(".kvs") > -1) ? s : (s + ".kvs"));
			writeFile();
		}
		
		/**
		 */		
		private function writeFile():void
		{
			isSaving = true;
			
			PerformaceTest.start("save");
			
			try
			{
				var writer:ZipFileWriter = new ZipFileWriter();// 这里每次都需要新建一个，全局writer的话第二次打开文件再保存会保存错误，将文件报废，再也打不开
				writer.addEventListener("zipFileCreated", fileSaved, false, 0, true);
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
				
			}
			catch (e:Error)
			{
				Bubble.show("保存数据出错，请重试！");
			}
			
			return;
			
			/*var pageData:ByteArray = core.thumbManager.getPageBytes(960, 720);
			if (pageData)
			{
				var vector:Vector.<ByteArray> = core.thumbManager.resolvePageData(pageData);
				var flag:int = 1;
				for each (var bytes:ByteArray in vector)
				{
					writer.addBytes(bytes, "pages/" + (flag++) + ".jpg");
				}
			}*/
			
		}
		
		/**
		 */		
		private function fileSaved(evt:Event):void
		{
			isSaving = false;
		}
		
		/**
		 * 是否正在保存文件，此时不能退出程序 
		 */		
		private var isSaving:Boolean = false;
		
	}
}