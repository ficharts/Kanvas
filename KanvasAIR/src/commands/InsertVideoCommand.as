package commands
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.ElementCreator;
	import util.LayoutUtil;
	import util.img.ImgLib;
	import util.layout.LayoutTransformer;
	import util.undoRedo.UndoRedoMannager;
	
	import view.element.video.VideoElement;
	import view.element.video.VideoVO;

	/**
	 * 
	 * @author wanglei
	 * 
	 */	
	public class InsertVideoCommand extends Command
	{
		public function InsertVideoCommand()
		{
			super();
		}
		
		/**
		 */		
		override public function execute(notification:INotification):void
		{
			sendNotification(Command.UN_SELECT_ELEMENT);
			
			videoFile = notification.getBody() as File;
			videoFile.addEventListener(Event.COMPLETE, fileLoaded);
			
			
			videoVO = new VideoVO;
			videoVO.id = ElementCreator.id;
			videoVO.url = videoFile.nativePath;
			videoVO.videoType = videoFile.extension;
			
			
			var layoutTransformer:LayoutTransformer = CoreFacade.coreMediator.layoutTransformer;
			var point:Point = LayoutUtil.stagePointToElementPoint(layoutTransformer.canvas.stage.stageWidth / 2, 
				layoutTransformer.canvas.stage.stageHeight / 2, layoutTransformer.canvas);
			
			videoVO.x = point.x;
			videoVO.y = point.y;
			videoVO.rotation = 0;
			videoVO.width = 400;
			videoVO.height = 300;
			videoVO.styleType = "video";
			videoVO.scale = layoutTransformer.compensateScale;
			
			// UI 初始化
			element = new VideoElement(videoVO);
			CoreFacade.addElement(element);
			
			//放置拖动创建时 当前原件未被指定 
			CoreFacade.coreMediator.currentElement = element;
			
			//开始缓动，将此设为false当播放完毕且鼠标弹起时进入选择状态
			CoreFacade.coreMediator.createNewShapeTweenOver = false;
			
			this.dataChanged();
			
			sendNotification(Command.SElECT_ELEMENT, element);
			UndoRedoMannager.register(this);
			
			//加载视频
			videoFile.load();
		}
		
		/**
		 */		
		private function fileLoaded(evt:Event):void
		{
			videoVO.source = new ByteArray;
			videoVO.source.writeBytes(videoFile.data, 0, videoFile.data.bytesAvailable);
		
			videoVO.videoID = ImgLib.imgID;
			ImgLib.register(videoVO.videoID.toString(), videoVO.source, videoVO.videoType);
		}
		
		/**
		 */		
		private var videoVO:VideoVO
		
		/**
		 */		
		private var element:VideoElement;
		
		/**
		 */		
		private var videoFile:File;
	}
}