package view.element.imgElement
{
	import view.element.ElementBase;

	/**
	 */	
	public class ImgLoadStateBase
	{
		public function ImgLoadStateBase(host:ImgElement)
		{
			this.element = host;
		}
		
		/**
		 * 加载状态下是无法复制的
		 */		
		public function clone():ElementBase
		{
			return null;
		}
		
		/**
		 * 加载状态下的渲染仅仅是渲染图片的代理品
		 */		
		public function render():void
		{
			
		}
		
		/**
		 */		
		public function loadingImg():void
		{
			
		}
		
		/**
		 */		
		protected var element:ImgElement;
	}
}