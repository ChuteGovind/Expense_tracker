package com.govind.expensetracker.dto;
import java.math.BigDecimal; import java.util.List;
public record DashboardResponse(BigDecimal totalIncome,BigDecimal totalExpenses,BigDecimal balance,List<CategorySummary> expenseByCategory,List<MonthlySummary> monthlyTrend) {}
