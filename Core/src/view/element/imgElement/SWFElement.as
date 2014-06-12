package view.element.imgElement
{
	import com.kvs.utils.extractor.SWFExtractor;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import model.vo.ElementVO;
	import model.vo.SWFVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;
	
	/**
	 */	
	public class SWFElement extends ImgElementBase
	{
		public function SWFElement(vo:ElementVO)
		{
			super(vo);
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var imgVO:SWFVO = new SWFVO;
			
			imgVO.viewData = null;
			imgVO.fileBytes = (this.imgVO as SWFVO).fileBytes;
			
			imgVO.url = this.imgVO.url;
			imgVO.imgID = this.imgVO.imgID;
			
			ElementUtil.cloneVO(imgVO, vo);
			
			var newElement:SWFElement = new SWFElement(imgVO);
			
			newElement.currLoadState = normalState;
			newElement.copyFrom = this;
			newElement.toNomalState();
			
			return newElement;
		}
		
		/**
		 */		
		override public function imgLoaded(fileBytes:ByteArray, viewData:Object):void
		{
			imgVO.viewData = viewData;
			(imgVO as SWFVO).fileBytes = fileBytes;
		}
		
		/**
		 */		
		override public function showIMG():void
		{
			
		}
		
		/**
		 */		
		override protected function initIMG(bmd:Object):void
		{
			if (imgVO.viewData)
			{
				initSWF(imgVO.viewData);
			}
			else
			{
				swfExtractor = new SWFExtractor();
				swfExtractor.addEventListener(Event.COMPLETE, swfLoaded, false, 0, true);
				swfExtractor.init((imgVO as SWFVO).fileBytes);
			}
		}
		
		/**
		 */		
		private function swfLoaded(evt:Event):void
		{
			initSWF(swfExtractor.view);
			
			swfExtractor = null;
		}
		
		/**
		 */		
		private function initSWF(data:Object):void
		{
			swf = data as Sprite;
			swf.x = - swf.width / 2;
			swf.y = - swf.height / 2;
			
			addChild(swf);
		}
		
		/**
		 */		
		private var swfExtractor:SWFExtractor;
		
		/**
		 */		
		public function checkBmdRender():void
		{
			
		}
		
		/**
		 */		
		override public function get canvas():DisplayObject
		{
			return swf;
		}
		
		/**
		 */		
		private var swf:Sprite;
		
	}
}