package model.vo
{
	import flash.display.BitmapData;
	
	/**
	 * 图片
	 */
	public class ImgVO extends ElementVO 
	{
		/**
		 */		
		public function ImgVO()
		{
			super();
			
			type = 'img';
			styleType = 'img';
		}
		
		override public function clone():ElementVO
		{
			var vo:ImgVO = super.clone() as ImgVO;
			vo.url = url;
			vo.sourceData = sourceData;
			vo.imgID = imgID;
			return vo;
		}
		
		override public function exportData():XML
		{
			xml = super.exportData();
			xml.@url = url;
			xml.@imgID = imgID;
			return xml;
		}
		
		/**
		 * 图片上传至服务器后，分配url, 后继再编辑时
		 * 
		 * 根据此URL向服务器请求图片数据;
		 */		
		public var url:String = '';
		
		/**
		 * 图片的原始数据
		 */		
		public var sourceData:BitmapData;
		
		/**
		 * 图片的原始数据id, 复制时，原始ID不变，
		 */		
		public var imgID:uint = 0;
		
		
		
	}
}