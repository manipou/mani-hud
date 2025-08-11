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
		const formattedValue = Separator ? value.toLocaleString() : value.toString();
		
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
<div class="fixed top-[3vh] right-[2vh] flex flex-col items-end pointer-events-none font-['Inter'] select-none">
    <!-- Main Stats Container -->
    <div class="relative">
        <!-- Stats Panel -->
        <div class="w-[18vh] bg-slate-900/95 rounded-[0.2vh] overflow-hidden border border-slate-600/30 shadow-lg transition-all duration-200 hover:border-slate-500/40">
            <!-- Cash -->
            <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-slate-700/30 hover:bg-slate-800/30 transition-all duration-200 group">
                <div class="flex items-center gap-[0.6vh]">
                    <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-emerald-600/90 rounded-[0.2vh] shadow-md group-hover:shadow-emerald-500/20 transition-all duration-200">
                        <i class="fas fa-wallet text-white text-[1vh]"></i>
                    </div>
                    <span class="text-slate-300 text-[1.2vh] font-medium">Cash</span>
                </div>
                <span class="text-emerald-300/90 text-[1.2vh] font-medium font-['JetBrains_Mono']">
                    {formatCurrency(Math.floor($money))}
                </span>
            </div>
        
            <!-- Bank -->
            <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-slate-700/30 hover:bg-slate-800/30 transition-all duration-200 group">
                <div class="flex items-center gap-[0.6vh]">
                    <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-blue-600/90 rounded-[0.2vh] shadow-md group-hover:shadow-blue-500/20 transition-all duration-200">
                        <i class="fas fa-university text-white text-[1vh]"></i>
                    </div>
                    <span class="text-slate-300 text-[1.2vh] font-medium">Bank</span>
                </div>
                <span class="text-blue-300/90 text-[1.2vh] font-medium font-['JetBrains_Mono']">
                    {formatCurrency(Math.floor($bank))}
                </span>
            </div>
        
            <!-- Black Money -->
            {#if $blackMoney > 0}
                <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-slate-700/30 hover:bg-slate-800/30 transition-all duration-200 group">
                    <div class="flex items-center gap-[0.6vh]">
                        <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-red-600/90 rounded-[0.2vh] shadow-md group-hover:shadow-red-500/20 transition-all duration-200">
                            <i class="fas fa-money-bill-wave text-white text-[1vh]"></i>
                        </div>
                        <span class="text-slate-300 text-[1.2vh] font-medium">Dirty</span>
                    </div>
                    <span class="text-red-300/90 text-[1.2vh] font-medium font-['JetBrains_Mono']">
                        {formatCurrency(Math.floor($blackMoney))}
                    </span>
                </div>
            {/if}
        
            <!-- Job -->
            <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] hover:bg-slate-800/30 transition-all duration-200 group">
                <div class="flex items-center gap-[0.6vh]">
                    <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-purple-600/90 rounded-[0.2vh] shadow-md group-hover:shadow-purple-500/20 transition-all duration-200">
                        <i class="fas fa-briefcase text-white text-[1vh]"></i>
                    </div>
                    <span class="text-slate-300 text-[1.2vh] font-medium">Job</span>
                </div>
                <div class="flex flex-col items-end">
                    <span class="text-purple-300/90 text-[1.2vh] font-medium">
                        {$Hud.PlayerData.Job}
                    </span>
                    <span class="text-purple-300/60 text-[1vh] font-medium">
                        {$Hud.PlayerData.Grade}
                    </span>
                </div>
            </div>
        </div>
    </div>
</div>