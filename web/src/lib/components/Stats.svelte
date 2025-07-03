<script lang="ts">
	import { Hud } from "$lib/stores/VisibilityStore";
	import { tweened } from "svelte/motion";
	import { cubicOut } from "svelte/easing";

	// Tweened values for smooth animations
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

	// Update tweened values when Hud store changes
	$: {
		if ($Hud.PlayerData) {
			money.set($Hud.PlayerData.Money);
			bank.set($Hud.PlayerData.Bank);
			blackMoney.set($Hud.PlayerData.BlackMoney);
		}
	}

	// Format currency with commas
	function formatCurrency(value: number): string {
		return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
	}
</script>

<svelte:head>
	<link href="https://fonts.googleapis.com/css2?family=Share+Tech&display=swap" rel="stylesheet">
</svelte:head>

<!-- Stats container in top right corner with holographic cyan styling -->
<div class="fixed top-[1.5vh] right-[1.5vh] flex flex-col items-end gap-[1vh] pointer-events-none">
	<!-- Server info with logo and player count -->
	<div class="flex items-center gap-2 bg-black/40 px-[1vh] py-[0.5vh] rounded-sm border border-cyan-400/20">
		<!-- Player count -->
		<div class="flex items-center">
			<div class="w-[0.6vh] h-[0.6vh] rounded-full bg-green-400 mr-[0.8vh] animate-pulse"></div>
			<span class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)]">
				{$Hud.PlayerCount}
			</span>
		</div>
		
		<!-- Server logo -->
		{#if $Hud.ServerLogo}
			<img src={$Hud.ServerLogo} alt="Server Logo" class="h-[2.2vh] w-auto object-contain ml-1" />
		{/if}
	</div>
	
	<!-- Player job info -->
	<div class="bg-black/40 px-[1vh] py-[0.5vh] rounded-sm border border-cyan-400/20 mb-[0.5vh]">
		<div class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)]">
			{$Hud.PlayerData.Job}
			<span class="text-cyan-300/70 text-[1vh] ml-1">{$Hud.PlayerData.Grade}</span>
		</div>
	</div>
	
	<!-- Money info -->
	<div class="bg-black/40 px-[1vh] py-[0.5vh] rounded-sm border border-cyan-400/20 w-[16vh]">
		<!-- Cash -->
		<div class="flex justify-between items-center mb-[0.5vh]">
			<span class="text-cyan-300/70 text-[1vh] tracking-wider">CASH</span>
			<span class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)]">
				${formatCurrency(Math.floor($money))}
			</span>
		</div>
		
		<!-- Bank -->
		<div class="flex justify-between items-center mb-[0.5vh]">
			<span class="text-cyan-300/70 text-[1vh] tracking-wider">BANK</span>
			<span class="text-cyan-300 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(0,195,255,0.7)]">
				${formatCurrency(Math.floor($bank))}
			</span>
		</div>
		
		<!-- Black Money (only show if has some) -->
		{#if $blackMoney > 0}
			<div class="flex justify-between items-center">
				<span class="text-red-400/70 text-[1vh] tracking-wider">DIRTY</span>
				<span class="text-red-400 text-[1.2vh] font-bold tracking-wider drop-shadow-[0_0_3px_rgba(255,0,0,0.7)]">
					${formatCurrency(Math.floor($blackMoney))}
				</span>
			</div>
		{/if}
	</div>
</div>