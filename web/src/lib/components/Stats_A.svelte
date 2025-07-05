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
		bank: "fa-landmark",
		black: "fa-coins",
		job: "fa-briefcase"
	};
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&family=Roboto+Mono:wght@400;700&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</svelte:head>

<!-- Compact stats container with side-by-side layout like the reference image -->
<div class="fixed top-[4vh] right-[1.5vh] flex flex-col items-end pointer-events-none">
    <div class="absolute left-0 top-[3.2vh] w-[3.4vw]">
        {#if $Hud.ServerLogo}
            <img src={$Hud.ServerLogo} alt="Server Logo" class="w-full h-full object-contain opacity-80" />
        {/if}
    </div>
    <!-- Top row with voice status, date/time, player ID, count -->
    <div class="flex justify-end items-center gap-[0.8vh] mb-[0.8vh] h-[2.4vh]">
        <!-- Voice status and range -->
        <div class="bg-blue-950/90 px-[1vh] py-[0.4vh] rounded-[0.4vh] border border-blue-500/30 shadow-md shadow-blue-900/30 flex items-center gap-[0.8vh] h-full">
            <div class="flex items-center justify-center w-[1.4vh]">
                <i class="fas fa-microphone{$Hud.Talking ? '' : '-slash'} text-[1.4vh] transition-colors duration-200 {$Hud.Talking ? 'text-blue-400 animate-pulse' : 'text-blue-300/50'}"></i>
            </div>
            
            <!-- Voice range indicator -->
            <div class="flex items-center justify-center w-[1.4vh]">
                {#if $Hud.VoiceRange === 1}
                    <i class="fas fa-volume-off text-[1.4vh] text-blue-300/90"></i>
                {:else if $Hud.VoiceRange === 2}
                    <i class="fas fa-volume-down text-[1.4vh] text-blue-300/90"></i>
                {:else if $Hud.VoiceRange === 3}
                    <i class="fas fa-volume-up text-[1.4vh] text-blue-300/90"></i>
                {/if}
            </div>
        </div>
        
        <!-- Player ID and count -->
        <div class="bg-blue-950/90 px-[1vh] py-[0.4vh] rounded-[0.4vh] border border-blue-500/30 shadow-md shadow-blue-900/30 flex items-center gap-[0.8vh] h-full">
            <!-- ID -->
            <div class="flex items-center gap-[0.4vh]">
                <i class="fas fa-id-card text-blue-300/90 text-[1.2vh]"></i>
                <span class="text-blue-300 text-[1.2vh] font-medium">{$Hud?.Id ?? '---'}</span>
            </div>
            
            <!-- Player count with pulse indicator -->
            {#if $Hud.PlayerCount}
                <div class="flex items-center gap-[0.4vh]">
                    <div class="w-[0.5vh] h-[0.5vh] rounded-full bg-green-400 animate-pulse"></div>
                    <span class="text-blue-300 text-[1.2vh] font-medium">{$Hud.PlayerCount}</span>
                </div>
            {/if}
        </div>
        
        <!-- Date and time -->
        <div class="bg-blue-950/90 px-[1vh] py-[0.4vh] rounded-[0.4vh] border border-blue-500/30 shadow-md shadow-blue-900/30 flex items-center gap-[0.8vh] h-full">
            <!-- Date icon and text -->
            <div class="flex items-center gap-[0.4vh]">
                <i class="fas fa-calendar-alt text-blue-300/90 text-[1.2vh]"></i>
                <span class="text-blue-300 text-[1.2vh] font-medium">{currentDate}</span>
            </div>
            
            <!-- Time icon and text -->
            <div class="flex items-center gap-[0.4vh]">
                <i class="far fa-clock text-blue-300/90 text-[1.2vh]"></i>
                <span class="text-blue-300 text-[1.2vh] font-medium">{currentTime}</span>
            </div>
        </div>
    </div>
    
    <!-- Main container with relative positioning for logo placement -->
    <div class="relative">
        <!-- Main stats box - side by side layout -->
        <div class="w-[18vh] bg-blue-950/90 rounded-[0.2vh] overflow-hidden border border-blue-500/30 shadow-md shadow-blue-900/30">
        <!-- Cash row -->
        <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-blue-800/30">
            <div class="flex items-center gap-[0.6vh]">
                <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-green-600/90 rounded-[0.4vh] border border-green-500/30">
                    <i class="fas fa-wallet text-white text-[1vh]"></i>
                </div>
                <span class="text-blue-300/90 text-[1.2vh]">Kontant</span>
            </div>
            <span class="text-blue-300 text-[1.2vh] font-medium drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                {formatCurrency(Math.floor($money))}
            </span>
        </div>
        
        <!-- Bank row -->
        <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-blue-800/30">
            <div class="flex items-center gap-[0.6vh]">
                <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-blue-600/90 rounded-[0.4vh] border border-blue-500/30">
                    <i class="fas fa-university text-white text-[1vh]"></i>
                </div>
                <span class="text-blue-300/90 text-[1.2vh]">Bank</span>
            </div>
            <span class="text-blue-300 text-[1.2vh] font-medium drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                {formatCurrency(Math.floor($bank))}
            </span>
        </div>
        
        <!-- Black money row (only if has some) -->
        {#if $blackMoney > 0}
            <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-blue-800/30">
                <div class="flex items-center gap-[0.6vh]">
                    <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-red-600/90 rounded-[0.4vh] border border-red-500/30">
                        <i class="fas fa-money-bill-wave text-white text-[1vh]"></i>
                    </div>
                    <span class="text-red-300/90 text-[1.2vh]">Sorte</span>
                </div>
                <span class="text-red-300 text-[1.2vh] font-medium drop-shadow-[0_0_1px_rgba(255,0,0,0.7)]">
                    {formatCurrency(Math.floor($blackMoney))}
                </span>
            </div>
        {/if}
        
        <div class="flex items-center justify-between px-[0.8vh] py-[0.5vh] border-b border-blue-800/30">
            <div class="flex items-center gap-[0.6vh]">
                <div class="w-[1.8vh] h-[1.8vh] flex items-center justify-center bg-purple-600/90 rounded-[0.4vh] border border-purple-500/30">
                    <i class="fas fa-briefcase text-white text-[1vh]"></i>
                </div>
                <span class="text-blue-300/90 text-[1.2vh]">Job</span>
            </div>
            <span class="text-blue-300 text-[1.2vh] font-medium drop-shadow-[0_0_1px_rgba(0,100,255,0.7)]">
                {$Hud.PlayerData.Job} - {$Hud.PlayerData.Grade}
            </span>
        </div>
        </div>
    </div>
</div>