package model.vo
{
	import flash.display.Sprite;
	import flash.utils.ByteArray;

	/**
	 *
	 *  
	 * @author wanglei
	 * 
	 */	
	public class SWFVO extends ImgVO
	{
		public function SWFVO()
		{
			super();
			
			type = 'swf';
			styleType = 'img';
		}
		
		/**
		 */		
		override public function clone():ElementVO
		{
			var vo:SWFVO = super.clone() as SWFVO;
			vo.url = url;
			vo.viewData = viewData;
			vo.imgID = imgID;
			
			return vo;
		}
		
		/**
		 * 适量图的复制得依靠对原始文件数据的重新加载, 生成新的sprite显示对象 
		 */		
		public var fileBytes:ByteArray;
		
	}
}