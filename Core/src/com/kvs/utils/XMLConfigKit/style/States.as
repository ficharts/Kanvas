package com.kvs.utils.XMLConfigKit.style
{
	import com.kvs.utils.XMLConfigKit.XMLVOMapper;

	/**
	 */	
	public class States extends Style
	{
		public function States()
		{
			super();
		}
		
		/**
		 */		
		override public function set radius(value:Number):void
		{
			super.radius = value;
			
			this._out.radius = value;
			
			if (_hover)
				this._hover.radius = this._down.radius = value; 
		}
		
		/**
		 */		
		override public function set width(value:Number):void
		{
			super.width = value;
			
			this._out.width = value;
				
			if (this._hover)
				this._hover.width = this._down.width = value; 
		}
		
		/**
		 */		
		override public function set height(value:Number):void
		{
			super.height = value;
			
			this._out.height = value;
				
			if (this._hover)
				this._hover.height = this._down.height = value; 
		}
		
		/**
		 */		
		override public function set tx(value:Number):void
		{
			super.tx = value;
			
			this._out.tx = value;
				
			if (this._hover)
				this._hover.tx = this._down.tx = value; 
		}
		
		/**
		 */		
		override public function set ty(value:Number):void
		{
			super.ty = value;
			this._out.ty = value;
			
			if (this._hover)
				this._hover.ty = this._down.ty = value; 
		}
		
		/**
		 */		
		private var _out:Style;

		/**
		 */
		public function get normal():Object
		{
			return _out;
		}

		/**
		 * @private
		 */
		public function set normal(value:Object):void
		{
			_out = XMLVOMapper.updateObject(value, _out, "style", this) as Style;
		}
		
		/**
		 */		
		public function get getNormal():Style
		{
			return _out;
		}

		/**
		 */		
		private var _hover:Style;

		/**
		 */
		public function get hover():Object
		{
			return _hover;
		}

		/**
		 * @private
		 */
		public function set hover(value:Object):void
		{
			_hover = XMLVOMapper.updateObject(value, _hover, "style", this) as Style;
		}
		
		/**
		 */		
		public function get getHover():Style
		{
			return _hover;
		}

		/**
		 */		
		private var _down:Style;

		/**
		 */
		public function get down():Object
		{
			return _down;
		}

		/**
		 * @private
		 */
		public function set down(value:Object):void
		{
			_down = XMLVOMapper.updateObject(value, _down, "style", this) as Style;
		}
		
		/**
		 */		
		public function get getDown():Style
		{
			return _down;
		}

	}
}