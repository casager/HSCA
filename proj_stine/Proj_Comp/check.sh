#!/bin/sh
echo "div64 rne"
cat f64_div_rne.out | grep '0$'
echo "div64 rd"
cat f64_div_rd.out | grep '0$'
echo "div64 ru"
cat f64_div_ru.out | grep '0$'
echo "div64 rz"
cat f64_div_rz.out | grep '0$'
sleep 1
echo "div32 rne"
cat f32_div_rne.out | grep '0$'
echo "div32 rd"
cat f32_div_rd.out | grep '0$'
echo "div32 ru"
cat f32_div_ru.out | grep '0$'
echo "div32 rz"
cat f32_div_rz.out | grep '0$'
sleep 1
echo "sqrt64 rne"
cat f64_sqrt_rne.out | grep '0$'
echo "sqrt64 rd"
cat f64_sqrt_rd.out | grep '0$'
echo "sqrt64 ru"
cat f64_sqrt_ru.out | grep '0$'
echo "sqrt64 rz"
cat f64_sqrt_rz.out | grep '0$'
sleep 1
echo "sqrt32 rne"
cat f32_sqrt_rne.out | grep '0$'
echo "sqrt32 rd"
cat f32_sqrt_rd.out | grep '0$'
echo "sqrt32 ru"
cat f32_sqrt_ru.out | grep '0$'
echo "sqrt32 rz"
cat f32_sqrt_rz.out | grep '0$'
