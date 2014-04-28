package com.kvs.utils.XMLConfigKit.shape
{
	import com.kvs.utils.XMLConfigKit.style.States;
	import com.kvs.utils.XMLConfigKit.style.Style;
	
	import flash.display.Sprite;

	public interface IShape
	{
		function render(canvas:Sprite, metadata:Object):void;
		
		/**
		 */		
		function get style():Style;
		
		/**
		 */		
		function set style(value:Style):void;
		
		/**
		 */		
		function get states():States;
		
		/**
		 */		
		function set states(value:States):void;
		
		/**
		 */		
		function set size(value:uint):void;
		
		/**
		 */		
		function get size():uint;
		
		/**
		 */		
		function set angle(value:int):void;
		
		/**
		 */		
		function get angle():int
		
	}
}