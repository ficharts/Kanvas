package
{
	import com.coltware.airxzip.ZipEntry;
	import com.coltware.airxzip.ZipFileReader;
	import com.coltware.airxzip.ZipFileWriter;
	import com.kvs.utils.PerformaceTest;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import model.ConfigInitor;
	import model.CoreFacade;
	import model.vo.PageVO;
	
	import modules.PreziDataImporter;
	import modules.pages.PageManager;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.ISource;
	import view.element.video.VideoElement;
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
			
			cr = Bitmap(new Copyright);
			core.addEventListener(KVSEvent.SET_VIDEO_URL, setVideoURLHandler);
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
		
		/**
		 */		
		override public function openTemplate(path:String):void
		{
			var path:String = File.applicationDirectory.nativePath + "/" + path;
			var file:File = new File(path);
			
			if (file.exists)
				openFile(file, true);
			else
				Bubble.show("模板文件不存在！");
		}
		
		/**
		 * 当前文件
		 */		
		public var file:File;
		
		/**
		 */		
		private var kanvasAIR:KanvasAIR;
		
		/**
		 * 打开文件 
		 */		
		public function openFile(newfile:File = null, template:Boolean = false):void
		{
			if (newfile)
			{
				this.file = newfile;
				var extension:String = file.extension.toLowerCase();
				
				if (extension == "kvs") readFileKVS();
				else if (extension == "pez") readFilePEZ();
				if (template || extension == "pez") file = null;
			}
			else
			{
				file = new File;
				file.addEventListener(Event.SELECT, fileSelected);
				file.browse([new FileFilter("kvs", "*.kvs")]);
			}
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
			var assetID:String;
				
			var imgData:ByteArray;
			var fileName:String;
			
			for each(var entry:ZipEntry in list)
			{
				if(entry.getFilename() == "kvs.xml")
				{
					xml = reader.unzip(entry).toString();
				}
				else
				{
					imgData = reader.unzip(entry);
					fileName = entry.getFilename();
					assetID = fileName.split('.')[0].toString();
					
					if (uint(assetID) != 0)
						ImgLib.register(assetID, imgData, fileName.split('.')[1].toString());
				}
			}
			
			reader.close();
			PerformaceTest.end("文件解压缩结束");
			
			PerformaceTest.start("解析xml");
			this.setXMLData(xml);
			PerformaceTest.end("xml解析结束");
			
			unsetUnusedAssets();
		}
		
		/**
		 * 含有视频的kvs文件再次编辑时需要重新配置视频文件的url
		 */		
		private function setVideoURLHandler(evt:KVSEvent):void
		{
			var video:VideoElement = evt.element as VideoElement;
			video.videoVO.url = fileBasePath + "/" + video.fileName;
			
			video.reset();
		}
		
		/**
		 */		
		private function writeFile():void
		{
			isSaving = true;
			
			PerformaceTest.start("save");
			
			unsetUnusedAssets();
			
			try
			{
				var writer:ZipFileWriter = new ZipFileWriter();// 这里每次都需要新建一个，全局writer的话第二次打开文件再保存会保存错误，将文件报废，再也打不开
				writer.addEventListener("zipFileCreated", fileSaved, false, 0, true);
				writer.openAsync(this.file);
				
				// file info
				var fileData:ByteArray = new ByteArray();
				fileData.writeUTFBytes(this.getXMLData());
				writer.addBytes(fileData,"kvs.xml");
				
				//图片相关
				var imgIDs:Array = ImgLib.keys;
				var imgDataBytes:ByteArray;
				
				//缩略图
				var bmd:BitmapData = core.thumbManager.getShotCut(ConfigInitor.THUMB_WIDTH, ConfigInitor.THUMB_HEIGHT);
				if (bmd)
				{
					imgDataBytes = bmd.encode(bmd.rect, new PNGEncoderOptions);
					writer.addBytes(imgDataBytes,"preview.png");
					
					//保存缩略图用于模版截图
					saveFileImageForTemplate(imgDataBytes);
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
					
					writer.addBytes(imgDataBytes,imgID.toString() + '.' + ImgLib.getType(imgID));
				}
				
				writer.close();
				saveVideos();
				
				
				PerformaceTest.end("save");
			}
			catch (e:Error)
			{
				Bubble.show("保存数据出错，请重试！");
			}
			
			return;
		}
		
		/**
		 * 保存视频文件，已经保存了的视频不用再保存，无效的视频删除
		 */		
		private function saveVideos():void
		{
			var videoes:Vector.<VideoElement> = core.videoes;
			
			//获取存储视频的目录
			var videoDirPath:String = fileBasePath;
			var dir:File = new File(videoDirPath);
			
			if (videoes.length == 0) 
			{
				if (dir.exists)
					dir.moveToTrash();
				
				return;// 没有视频文件, 停止执行
			}
			
			dir.createDirectory();
			
			var video:VideoElement;
			var videoFile:File;
			var videoesName:Array = [];
			
			//保存视频文件
			for each (video in videoes)
			{
				videoesName.push(video.fileName);
				videoFile = new File(videoDirPath + "/" + video.fileName);
				
				if (videoFile.exists == false)
				{
					var fs:FileStream = new FileStream();
					fs.open(videoFile, FileMode.WRITE);
					fs.position = 0
					fs.writeBytes(video.data, 0, video.data.bytesAvailable);
					fs.close();
				}
			}
			
			
			//获取视频目录下的文件, 如果某个文件不包含在视频文件列表中，则删除此视频文件
			var savedFiles:Array = dir.getDirectoryListing();
			for each (var sfile:File in savedFiles)
			{
				if (videoesName.indexOf(sfile.name) == - 1)
				{
					videoFile = new File(videoDirPath + "/" + sfile.name);
					if (videoFile.exists)
						videoFile.moveToTrash();
				}
			}
			
		}
		
		/**
		 * 获取相对与当前文件，其视频文件要保存的文件夹
		 */		
		private function get fileBasePath():String
		{
			var filePath:String = file.nativePath;
			filePath = filePath.split(".")[0] ;
			
			return filePath;
		}
		
		/**
		 * 将没有用到的资源卸载掉
		 */		
		private function unsetUnusedAssets():void
		{
			var sourceEles:Array = eleIDsHasAsset;
			var assetIDs:Array = ImgLib.keys;
			
			//如果数据中的图片id不存在于xml中，则说明此图片是多余图片，删除
			for each (var id:String in assetIDs)
			{
				if (sourceEles.indexOf(id) == - 1)
					ImgLib.unRegister(uint(id));
			}
		}
		
		/**
		 * 含有资源文件
		 */		
		private function get eleIDsHasAsset():Array
		{
			//这里需要清理冗余的图片数据
			var imgIDsInXML:Array = [];
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ISource)
					imgIDsInXML.push((element as ISource).dataID);
			}
			
			//不能忘记背景图
			if (CoreFacade.coreProxy.bgVO.imgID > 0)
				imgIDsInXML.push(CoreFacade.coreProxy.bgVO.imgID.toString());
			
			return imgIDsInXML;
		}
		
		/**
		 */		
		private function readFilePEZ():void
		{
			var reader:ZipFileReader = new ZipFileReader();
			reader.open(file);
			
			var list:Array = reader.getEntries();
			var fileName:String;
			
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
						ImgLib.register(imgID, imgData, name.split('.')[1].toString());
				}
			}
			
			setXMLData(PreziDataImporter.convertData(XML(xml)));
			
			unsetUnusedAssets();
			reader.close();
		}
		
		/**
		 */		
		public function exportImg():void
		{
			jpg = new File;
			jpg.nativePath = File.desktopDirectory.nativePath + "/微舞幻灯.png";
			jpg.addEventListener(Event.SELECT, selectJPGFileSave);
			jpg.addEventListener(Event.CANCEL, cancelJPGFileSave);
			jpg.browseForSave("保存png");
		}
		
		private function selectJPGFileSave(evt:Event):void
		{
			kanvasAIR.exportImgBtn.selected = false;
			jpg.removeEventListener(Event.SELECT, selectJPGFileSave);
			jpg.removeEventListener(Event.CANCEL, cancelJPGFileSave);
			
			var manager:PageManager = CoreFacade.coreMediator.pageManager;
			var l:int = manager.length;
			var gutter:int = 10;
			var w:Number = 800;
			var h:Number = 600;
			var flag:int = 30;
			var tw:Number = gutter + gutter + w;
			var num:int = 12;
			var bmds:Array = [];
			
			for (var i:int = 0; i < l; i++)
			{
				var m:int = i % num;
				if (m == 0)
				{
					//创建一张新的bmd存储
					var th:Number = (l - i > num) 
						? gutter + (h + gutter) * num
						: gutter + (h + gutter) * (l - i) + gutter + 300;
					var bmd:BitmapData = new BitmapData(tw, th, false, 0x555555);
					bmds.push(bmd);
					var mat:Matrix = new Matrix;
					mat.translate(gutter, gutter);
				}
				var page:PageVO = manager.pages[i];
				var pagBmd:BitmapData = (page.bitmapData) ? page.bitmapData : manager.getThumbByPageVO(page, w, h);
				bmd.draw(pagBmd, mat, null, null, null, true);
				mat.translate(0, h + gutter);
			}
			
			pagBmd = cr.bitmapData;
			bmd.draw(pagBmd, mat, null, null, null, true);
			
			var s:String = jpg.nativePath;
			jpg.nativePath = (s.indexOf(".png") > -1) ? s : (s + ".png");
			
			//小于num页，只存一张
			if (bmds.length == 1)
			{
				var dat:ByteArray = bmd.encode(bmd.rect, new PNGEncoderOptions(true));
				var fs:FileStream = new FileStream();
				fs.open(jpg,FileMode.WRITE);
				fs.position = 0;
				fs.writeBytes(dat);
				fs.close();
			}
			//多于num页，批量存储
			else if (bmds.length > 1)
			{
				l = bmds.length;
				s = jpg.nativePath;
				var t:String = s.substr(0, s.length - 4);
				for (i = 0; i < l; i++)
				{
					bmd = bmds[i];
					dat = bmd.encode(bmd.rect, new PNGEncoderOptions(true));
					jpg = new File(t + (i + 1) + ".png");
					fs = new FileStream();
					fs.open(jpg, FileMode.WRITE);
					fs.position = 0;
					fs.writeBytes(dat);
					fs.close();
				}
			}
			
			
			/*var th:Number = gutter + gutter + Math.min(l, flag) * (600 + gutter) + 300;
			var bmd:BitmapData = new BitmapData(tw, th, false, 0x555555);
			var mat:Matrix = new Matrix;
			mat.translate(gutter, gutter);
			for (var i:int = 0; i < l; i++)
			{
				if (i < flag)
				{
					var page:PageVO = manager.pages[i];
					var pagBmd:BitmapData = (page.bitmapData) ? page.bitmapData : manager.getThumbByPageVO(page, w, h);
					bmd.draw(pagBmd, mat, null, null, null, true);
					mat.translate(0, h + gutter);
				}
			}
			pagBmd = cr.bitmapData;
			bmd.draw(pagBmd, mat, null, null, null, true);
			
			var s:String = jpg.nativePath;
			
			jpg.nativePath = (s.indexOf(".png") > -1) ? s : (s + ".png");
			
			var dat:ByteArray = bmd.encode(bmd.rect, new PNGEncoderOptions(true));
			var fs:FileStream = new FileStream();
			fs.open(jpg,FileMode.WRITE);
			fs.position = 0;
			fs.writeBytes(dat);
			fs.close();*/
			//writeFile();
		}
		
		private function cancelJPGFileSave(evt:Event):void
		{
			jpg.removeEventListener(Event.SELECT, selectJPGFileSave);
			jpg.removeEventListener(Event.CANCEL, cancelJPGFileSave);
			jpg = null;
			kanvasAIR.exportImgBtn.selected = false;
		}
		
		private var jpg:File;
		
		private var cr:Bitmap;
		
		[Embed(source="assets/cr.png")]
		private static var Copyright:Class;
		
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
		 * 保存文件的缩略图, 给模版用
		 */		
		private function saveFileImageForTemplate(imgDataBytes:ByteArray):void
		{
			return;
			
			var fileImage:File = new File;
			fileImage.nativePath = "/Users/wanglei/projects/Kanvas/KanvasAIR/src/templates/images/" + file.name.split(".")[0] + ".png";
			
			var fs:FileStream = new FileStream();
			fs.open(fileImage, FileMode.WRITE);
			fs.position = 0;
			fs.writeBytes(imgDataBytes);
			fs.close();
		}
		
		/**
		 */		
		private function fileSaved(evt:Event):void
		{
			isSaving = false;
			kanvasAIR.saved();
		}
		
		/**
		 * 是否正在保存文件，此时不能退出程序 
		 */		
		private var isSaving:Boolean = false;
		
	}
}