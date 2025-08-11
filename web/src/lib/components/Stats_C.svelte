<script lang="ts">
	import { onDestroy } from 'svelte';
	import { tweened } from 'svelte/motion';
	import { cubicOut } from 'svelte/easing';
	import { Hud } from '$lib/stores/VisibilityStore';
	
	// Tweened money values for smooth animations
	const money = tweened(0, {
		duration: 600,
		easing: cubicOut
	});
	
	const bank = tweened(0, {
		duration: 600,
		easing: cubicOut
	});
	
	const blackMoney = tweened(0, {
		duration: 600,
		easing: cubicOut
	});
	
	$: {
		if ($Hud.PlayerData) {
			money.set($Hud.PlayerData.Money);
			bank.set($Hud.PlayerData.Bank);
			blackMoney.set($Hud.PlayerData.BlackMoney);
		}
	}
	
	// Format currency based on server config
	function formatCurrency(value: number): string {
		if (!$Hud?.Currency) return value.toLocaleString();
		
		const { Symbol, Position, Separator } = $Hud.Currency;
		// Use toLocaleString() for proper comma formatting
		const formattedValue = value.toLocaleString();
		
		return Position === 'before' 
			? `${Symbol} ${formattedValue}` 
			: `${formattedValue} ${Symbol}`;
	}
	
	// Date and time
	let currentDate = '';
	let currentTime = '';
	
	// Update date and time every minute
	function updateDateTime() {
		const now = new Date();
		
		// Format date as day.month
		const day = now.getDate();
		const month = now.getMonth() + 1;
		currentDate = `${day}. ${getMonthName(month)}`;
		
		// Format time as HH:MM (24-hour format)
		const hours = now.getHours().toString().padStart(2, '0');
		const minutes = now.getMinutes().toString().padStart(2, '0');
		currentTime = `${hours}:${minutes}`;
	}
	
	// Get abbreviated month name
	function getMonthName(month: number): string {
		const monthNames = ['jan', 'feb', 'mar', 'apr', 'maj', 'jun', 'jul', 'aug', 'sep', 'okt', 'nov', 'dec'];
		return monthNames[month - 1];
	}
	
	// Update time immediately and then every minute
	updateDateTime();
	const interval = setInterval(updateDateTime, 60000);
	
	// Clean up interval on component destruction
	onDestroy(() => {
		clearInterval(interval);
	});
	
	// Sample values for development/testing
	const sampleKasseValue = 10207680;
	
	// Define icons for each stat type
	const icons = {
		cash: "fa-wallet",
		bank: "fa-university",
		black: "fa-coins",
		job: "fa-briefcase"
	};
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</svelte:head>

<!-- Modern HUD Stats Container -->
<div class="absolute top-0 left-[calc(100%+0.5vh)] h-full flex flex-col justify-between items-start pointer-events-none font-['Inter'] select-none">
	<!-- Cash -->
	<div class="flex items-center gap-[0.8vh]">
		<div class="w-[0.2vh] h-[85%] bg-emerald-400 drop-shadow-md"></div>
		<div class="flex flex-col">
			<span class="text-white text-[1.4vh] font-bold drop-shadow-md leading-tight">
				Cash
			</span>
			<span class="text-emerald-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md leading-tight whitespace-nowrap">
				{formatCurrency(Math.floor($money))}
			</span>
		</div>
	</div>

	<!-- Bank -->
	<div class="flex items-center gap-[0.8vh]">
		<div class="w-[0.2vh] h-[85%] bg-blue-400 drop-shadow-md"></div>
		<div class="flex flex-col">
			<span class="text-white text-[1.4vh] font-bold drop-shadow-md leading-tight">
				Bank
			</span>
			<span class="text-blue-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md leading-tight whitespace-nowrap">
				{formatCurrency(Math.floor($bank))}
			</span>
		</div>
	</div>

	<div class="flex items-center gap-[0.8vh]">
		<div class="w-[0.2vh] h-[85%] bg-red-400 drop-shadow-md"></div>
		<div class="flex flex-col">
			<span class="text-white text-[1.4vh] font-bold drop-shadow-md leading-tight">
				Dirty
			</span>
			<span class="text-red-300 text-[1.2vh] font-medium font-['JetBrains_Mono'] drop-shadow-md leading-tight whitespace-nowrap">
				{formatCurrency(Math.floor($blackMoney))}
			</span>
		</div>
	</div>

	<!-- Job -->
	<div class="flex items-center gap-[0.8vh]">
		<div class="w-[0.2vh] h-[85%] bg-purple-400 drop-shadow-md"></div>
		<div class="flex flex-col">
			<span class="text-white text-[1.4vh] font-bold drop-shadow-md leading-tight">
				{$Hud.PlayerData.Job}
			</span>
			<span class="text-purple-300 text-[1.2vh] font-medium drop-shadow-md leading-tight">
				{$Hud.PlayerData.Grade}
			</span>
		</div>
	</div>
</div>