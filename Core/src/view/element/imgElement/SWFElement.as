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
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 */	
	public class SWFElement extends ImgElementBase implements IAutoGroupElement
		
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
			(imgVO as SWFVO).fileBytes = fileBytes;
			
			super.imgLoaded(fileBytes, viewData);
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
			swf = data;
			swf.x = - swf.width / 2;
			swf.y = - swf.height / 2;
			
			addChild(swf as DisplayObject);
			
			//底部绘制触控区域
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(swf.x, swf.y, swf.width, swf.height);
			graphics.endFill();
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
			return swf as DisplayObject;
		}
		
		/**
		 */		
		private var swf:Object;
		
	}
}