package landray.kp.maps.main.elements
{
	import model.vo.ElementVO;
	
	public final class Camera extends Element
	{
		public function Camera($vo:ElementVO)
		{
			super($vo);
			mouseEnabled = false;
		}
		
		override public function render():void
		{
			if(!rendered)
			{
				super.render();
				graphics.beginFill(0, 0);
				graphics.drawRect(vo.style.tx, vo.style.ty, vo.style.width, vo.style.height);
				graphics.endFill();
			}
		}
	}
}