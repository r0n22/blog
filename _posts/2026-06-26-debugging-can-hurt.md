---
layout: post
title: Debugging Can Hurt
date: 2026-06-26 14:44
category: 
author: Cameron Regan
tags: [Development]
summary: Don't debug performance with Debug.WriteLine 
---

# Debugging can hurt you

I was working on a performance issue.  In [dTris](https://mectiming.org/products/dtris/) my ski racing software,  racers were taking 1-2 seconds to get from the start of the race course to being in progress after we have heard the timer acknowledge the racer is on course.

In a regular program this might not be that bad but dTris is a real time application which requires that the user have quick refresh of the information. 
I started logging all the timings and calculate the time from intial pulse read to final refresh of UI, there was `Debug.WriteLine` statements everywhere!

I just could not get the system to perform any better.

Then reading stack overflow it someone asked why is `Debug.WriteLine` so slow?

So I did a test of my log4net vs Debug.Witeline. Debug for writeline was 20x slower than my internal logging.


<h2 class="sr-only">Line chart comparing Debug.WriteLine vs TimingLog performance across character counts from 0 to 2000</h2>

<div style="display: flex; flex-wrap: wrap; gap: 12px; margin: 1.5rem 0 0.5rem;">
  <div style="background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 0.75rem 1rem; min-width: 140px;">
    <p style="font-size: 12px; color: var(--color-text-secondary); margin: 0 0 4px;">Debug.WriteLine avg</p>
    <p style="font-size: 20px; font-weight: 500; margin: 0; color: var(--color-text-primary);">~460 µs</p>
  </div>
  <div style="background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 0.75rem 1rem; min-width: 140px;">
    <p style="font-size: 12px; color: var(--color-text-secondary); margin: 0 0 4px;">TimingLog avg</p>
    <p style="font-size: 20px; font-weight: 500; margin: 0; color: var(--color-text-primary);">~4.3 µs</p>
  </div>
  <div style="background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 0.75rem 1rem; min-width: 140px;">
    <p style="font-size: 12px; color: var(--color-text-secondary); margin: 0 0 4px;">Speed advantage</p>
    <p style="font-size: 20px; font-weight: 500; margin: 0; color: var(--color-text-primary);">~100×</p>
  </div>
  <div style="background: var(--color-background-secondary); border-radius: var(--border-radius-md); padding: 0.75rem 1rem; min-width: 140px;">
    <p style="font-size: 12px; color: var(--color-text-secondary); margin: 0 0 4px;">Iterations per run</p>
    <p style="font-size: 20px; font-weight: 500; margin: 0; color: var(--color-text-primary);">10,000</p>
  </div>
</div>

<div style="display: flex; flex-wrap: wrap; gap: 16px; margin: 1rem 0 0.5rem; font-size: 12px; color: var(--color-text-secondary);">
  <span style="display: flex; align-items: center; gap: 6px;">
    <svg width="28" height="12" aria-hidden="true"><line x1="0" y1="6" x2="28" y2="6" stroke="#378ADD" stroke-width="2.5"/><circle cx="14" cy="6" r="3.5" fill="#378ADD"/></svg>
    Debug.WriteLine (µs)
  </span>
  <span style="display: flex; align-items: center; gap: 6px;">
    <svg width="28" height="12" aria-hidden="true"><line x1="0" y1="6" x2="6" y2="6" stroke="#D4537E" stroke-width="2.5" stroke-dasharray="4,3"/><line x1="9" y1="6" x2="15" y2="6" stroke="#D4537E" stroke-width="2.5" stroke-dasharray="4,3"/><line x1="18" y1="6" x2="28" y2="6" stroke="#D4537E" stroke-width="2.5" stroke-dasharray="4,3"/><rect x="10.5" y="2.5" width="7" height="7" fill="#D4537E"/></svg>
    TimingLog (µs, right axis)
  </span>
</div>

<div style="position: relative; width: 100%; height: 340px;">
  <canvas id="timingChart" role="img" aria-label="Line chart showing Debug.WriteLine averages around 450-580 µs and TimingLog averages rising from 1.4 to 8.5 µs as character count increases from 0 to 2000.">Debug.WriteLine stays relatively flat around 450-580 µs; TimingLog rises from ~1.4 µs at 0 chars to ~8.5 µs at 2000 chars.</canvas>
</div>

<p style="font-size: 12px; color: var(--color-text-secondary); margin: 0.75rem 0 0; text-align: center;">Character count (string length passed to timing call)</p>

<script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.1/chart.umd.js"></script>
<script>
const labels = [0,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000];
const debugAvg = [583.42,466.87,412.30,411.92,416.92,435.21,463.81,463.10,465.08,446.14,443.36,464.07,446.38,450.38,512.92,474.00,469.75,462.76,475.86,472.31,477.79];
const timingAvg = [1.43,1.20,1.42,1.59,1.70,1.93,2.49,4.11,3.91,4.28,3.74,3.61,3.56,6.48,6.38,5.88,5.89,6.67,6.64,6.58,8.47];

const ctx = document.getElementById('timingChart').getContext('2d');
new Chart(ctx, {
  type: 'line',
  data: {
    labels,
    datasets: [
      {
        label: 'Debug.WriteLine avg (µs)',
        data: debugAvg,
        borderColor: '#378ADD',
        backgroundColor: 'rgba(55,138,221,0.08)',
        borderWidth: 2.5,
        pointRadius: 3,
        pointHoverRadius: 5,
        pointBackgroundColor: '#378ADD',
        pointStyle: 'circle',
        fill: true,
        tension: 0.3,
        yAxisID: 'yLeft'
      },
      {
        label: 'TimingLog avg (µs)',
        data: timingAvg,
        borderColor: '#D4537E',
        backgroundColor: 'rgba(212,83,126,0.0)',
        borderWidth: 2.5,
        borderDash: [6, 4],
        pointRadius: 3.5,
        pointHoverRadius: 5,
        pointBackgroundColor: '#D4537E',
        pointStyle: 'rect',
        fill: false,
        tension: 0.3,
        yAxisID: 'yRight'
      }
    ]
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    interaction: { mode: 'index', intersect: false },
    plugins: {
      legend: { display: false },
      tooltip: {
        callbacks: {
          title: (items) => `${items[0].label} chars`,
          label: (item) => {
            const val = item.parsed.y.toFixed(2);
            return ` ${item.dataset.label}: ${val} µs`;
          }
        },
        backgroundColor: 'rgba(30,30,30,0.88)',
        titleColor: '#ccc',
        bodyColor: '#fff',
        padding: 10,
        cornerRadius: 8
      }
    },
    scales: {
      x: {
        grid: { color: 'rgba(128,128,128,0.12)' },
        ticks: {
          color: '#888',
          font: { size: 11 },
          autoSkip: false,
          maxRotation: 45,
          callback: (val, i) => i % 2 === 0 ? labels[i] : ''
        },
        border: { color: 'rgba(128,128,128,0.2)' }
      },
      yLeft: {
        type: 'linear',
        position: 'left',
        title: {
          display: true,
          text: 'Debug.WriteLine avg (µs)',
          color: '#378ADD',
          font: { size: 12 }
        },
        min: 350,
        max: 650,
        grid: { color: 'rgba(128,128,128,0.12)' },
        ticks: {
          color: '#378ADD',
          font: { size: 11 },
          callback: v => v + ' µs'
        },
        border: { color: 'rgba(128,128,128,0.2)' }
      },
      yRight: {
        type: 'linear',
        position: 'right',
        title: {
          display: true,
          text: 'TimingLog avg (µs)',
          color: '#D4537E',
          font: { size: 12 }
        },
        min: 0,
        max: 11,
        grid: { drawOnChartArea: false },
        ticks: {
          color: '#D4537E',
          font: { size: 11 },
          callback: v => v.toFixed(1) + ' µs'
        },
        border: { color: 'rgba(128,128,128,0.2)' }
      }
    }
  }
});
</script>


After updating all my Debugging statements to use my internal debug logger the performance issue went away.


* Graph made by Claude

