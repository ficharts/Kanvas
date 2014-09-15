package commands
{
	import flash.utils.ByteArray;
	
	import model.CoreFacade;
	
	import org.puremvc.as3.interfaces.INotification;
	
	import util.img.ImgLib;
	
	import view.element.ElementBase;
	import view.element.imgElement.ImgElement;
	import view.element.imgElement.ImgElementBase;

	/**
	 */	
	public class DelImageFromAIRCMD extends DeleteImgCMDBase
	{
		public function DelImageFromAIRCMD()
		{
			super();
		}
		
		/**
		 * 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			super.execute(notification);
			
			//记录下图片数据
			imgByts = ImgLib.getData(element.imgVO.imgID);
			type =  ImgLib.getType(element.imgVO.imgID);
			
			// 判断如果系统中不再含有此图片ID的图片元素，则从图片库中删除此元素
			if (ifImgShared == false)
				ImgLib.unRegister(element.imgVO.imgID);
			
		}
		
		/**
		 */		
		private var type:String;
		
		/**
		 * 图片的数据 
		 */		
		private var imgByts:ByteArray;
		
		/**
		 */		
		override public function undoHandler():void
		{
			super.undoHandler();
			
			ImgLib.register(element.imgVO.imgID.toString(), imgByts, type);
		}
		
		/**
		 */		
		override public function redoHandler():void
		{
			super.redoHandler();
			
			ImgLib.unRegister(element.imgVO.imgID);
		}
		
		/**
		 */		
		private function get ifImgShared():Boolean
		{
			var isImgShared:Boolean = false;
			for each (var element:ElementBase in CoreFacade.coreProxy.elements)
			{
				if (element is ImgElementBase && (element as ImgElementBase).imgVO.imgID == this.element.imgVO.imgID)
				{
					isImgShared = true;
					break;
				}
			}
			
			return isImgShared;
		}
	}
}