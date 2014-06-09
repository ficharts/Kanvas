package view.element.imgElement
{
	import com.kvs.utils.RexUtil;
	
	import landray.kp.ui.Loading;
	
	import model.vo.ElementVO;
	import model.vo.ImgVO;
	
	import view.element.ElementBase;
	import view.element.ElementEvent;
	import view.interact.autoGroup.IAutoGroupElement;
	
	/**
	 */	
	public class ImgElementBase extends ElementBase implements IAutoGroupElement
	{
		public function ImgElementBase(vo:ElementVO)
		{
			super(vo);
			
			
			autoGroupChangable = false;
			
			// 图片加载状态初始化
			loadingState = new LoadingState(this);
			normalState = new NormalState(this);
			currLoadState = loadingState;
		}
		
		
		
		
		
		
		
		
		
		//------------------------------------------
		//
		//
		// 图片有两种特殊状态： 加载状态和正常状态
		//
		// 默认为加载状态，此时正在加载/上传图片
		//
		//
		//------------------------------------------
		
		
		/**
		 */		
		public function toNomalState():void
		{
			graphics.clear();
			
			currLoadState = normalState;
			removeLoading();
			imgVO.width  = imgVO.sourceData.width;
			imgVO.height = imgVO.sourceData.height;
			initBmp(imgVO.sourceData);
			currLoadState.render();
			
			dispatchEvent(new ElementEvent(ElementEvent.IMAGE_TO_RENDER));
		}
		
		/**
		 */		
		protected function initBmp(bmd:Object):void
		{
			
		}
		
		/**
		 */		
		public function showBmp():void
		{
		}
		
		/**
		 * 渲染
		 */
		override public function render():void
		{
			rendered = true;
			super.render();
			
			// 图片插入时
			if (imgVO.sourceData)
				currLoadState.render();
			else if (imgVO.url != "null" && RexUtil.ifHasText(imgVO.url))// 再次编辑时从服务器载入图片, 或者从内存中加载图片
				currLoadState.loadingImg();
			else if (CoreApp.isAIR)
				currLoadState.loadingImg();
			
		}
		
		private var rendered:Boolean;
		
		/**
		 * 
		 * 元素的原始尺寸 乘以 缩放比例  = 实际尺寸；
		 * 
		 */		
		override public function get scaledWidth():Number
		{
			return vo.width * vo.scale;		
		}
		
		/**
		 */		
		override public function get scaledHeight():Number
		{
			return vo.height * vo.scale;
		}
		
		/**
		 */		
		override public function del():void
		{
			dispatchEvent(new ElementEvent(ElementEvent.DEL_IMG, this));
		}
		
		/**
		 */		
		override public function clone():ElementBase
		{
			return null;
		}
		
		/**
		 */		
		override protected function init():void
		{
			preRender();
			render();
		}
		
		/**
		 */		
		internal function createLoading():void
		{
			if(!loading) 
				addChild(loading = new Loading);
			
			loading.play();
		}
		
		internal function removeLoading():void
		{
			if (loading) 
			{
				if (contains(loading)) 
					removeChild(loading)
				
				loading.stop();
				loading = null;
			}
		}
		
		/**
		 */		
		private var loading:Loading;
		
		/**
		 */		
		internal function drawLoading():void
		{
			graphics.clear();
			graphics.beginFill(0x555555, 0.3);
			graphics.drawRect( - vo.width / 2, - vo.height / 2, vo.width, vo.height);
			graphics.endFill();
			
			createLoading();
		}
		
		/**
		 */		
		public function get imgVO():ImgVO
		{
			return vo as ImgVO;
		}
		
		/**
		 */		
		internal var currLoadState:ImgLoadStateBase;
		internal var loadingState:ImgLoadStateBase;
		internal var normalState:ImgLoadStateBase;
	}
}