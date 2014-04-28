package view.element.imgElement
{
	import model.vo.ImgVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;

	public class NormalState extends ImgLoadStateBase
	{
		public function NormalState(host:ImgElement)
		{
			super(host);
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			var imgVO:ImgVO = new ImgVO;
			imgVO.sourceData = element.imgVO.sourceData;
			imgVO.url = element.imgVO.url;
			imgVO.imgID = element.imgVO.imgID;
			
			ElementUtil.cloneVO(imgVO, element.vo);
			var newElement:ImgElement = new ImgElement(imgVO);
			newElement.currLoadState = element.normalState;
			
			newElement.toNomalState();
			
			return newElement;
		}
		
		/**
		 */		
		override public function render():void
		{
			element.showBmp();
		}
	}
}