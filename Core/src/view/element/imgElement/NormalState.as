package view.element.imgElement
{
	import model.vo.ImgVO;
	
	import util.ElementUtil;
	
	import view.element.ElementBase;

	public class NormalState extends ImgLoadStateBase
	{
		public function NormalState(host:ImgElementBase)
		{
			super(host);
		}
		
		/**
		 */		
		override public function render():void
		{
			element.showIMG();
		}
	}
}